# Load dependencies. Require converted font resource file
require "gui/fonts/fonts.qrc.rb"

# A mere extension of a widget with custom fonts.
# Loads fonts on runtime, should occur only once,
# namely at the first found CustomFontWidget. Other
# instances should borrow the fonts from this parent.
class CustomFontWidget < Qt::Widget

	# Public declarations
	public

		# Declare accessible font-related attributes
    attr_reader :font_light  , :font_light_italic, :font_light_bold,
                :font_regular, :font_italic,
                :font_bold   , :font_bold_italic,
                :font_black  , :font_black_italic

    # Include log4r
    include Logging

		# Parametrized constructor, initializes the
		# widget, given the parent and the window flags.
		def initialize(p_parent)

			@parent = p_parent
			super(p_parent)
			
			# Declare constants
			@@settings = {
        :default_font_size => 9,
        :font_path => "./../gui/fonts",
        :typeface => "PTSans"
      }.freeze

      # Initialize class fields
      @@font_db = nil

      # Initialize fields
      @font_light   = nil; @font_light_italic = nil; @font_light_bold = nil
      @font_regular = nil; @font_italic       = nil
      @font_bold    = nil; @font_bold_italic  = nil
      @font_black   = nil; @font_black_italic = nil

      # Self-explanatory method call
			borrow_or_set_font
		end
		
		# Derives a font with the given style and size,
    # based upon the custom font families currently
    # in use.
    #
    # Params: base  -- The base font to use, one of [Qt::Font::Light, Qt::Font::Normal ..]
    #         style -- The style to be used, e.g. [Qt::Font::StyleNormal, Qt::Font::StyleItalic ..]
    #
    #         size  -- The size of the font to create (Default @@settings[:default_font_size]) [Optional]
		def derive_font(p_args)
      begin

        # Recalibrate parameters
        p_args[:style] || Qt::Font::StyleNormal
        p_args[:size]  ||= @@settings[:default_font_size]

        # Get base font by matching parameter, has to be demux'd, a bit ugly
        case p_args[:base]
          when Qt::Font::Light
            base_font_s = "@font_light"

          when Qt::Font::Normal
            base_font_s = "@font_regular"

          when Qt::Font::Bold
            base_font_s = "@font_bold"

          else # includes when Qt::Font::Black
            base_font_s = "@font_black"
        end

        # Apply italic style, if required. StyleOblique is ignored.
        base_font_s += "_italic" if p_args[:style] == Qt::Font::StyleItalic

        # Retrieve instance var, break if not available
        base_font = instance_variable_get(base_font_s.to_sym)
        return nil if base_font.nil?

        # Derive a new font using the FontDatabase
        font = @@font_db.font(base_font.family, p_args[:base].to_s.capitalize, p_args[:size])
        apply_font_properties(font)

        # Return result
        font

      # Rescue any exception
      rescue Exception => e
        log.error e
      end
    end

    # Overriden Event Handler, don't forget
    # to call super if overriding!
    #
    # Checks if any children widgets require
    # fonts not yet added to the FontDatabase.
    # If so, adds to DB and assigns to widgets
    def showEvent(p_event)
      apply_custom_font_styles
    end

	# Private declarations
	private

    # Isolates the font-related instance variables (that is,
    # the font_<weight> instance variables) into a collection
    def font_related_instance_variable_names
      instance_variables.select { |instance_variable_s| instance_variable_s.include?("font_") }
    end

    # Gets the actual values of the font-related instance variables,
    # as retrieved by font_related_instance_variable_names
    def font_related_instance_variables
      result = []
      font_related_instance_variable_names.each do |instance_variable_name|
        result << instance_variable_get(instance_variable_name)
      end
      result
    end

    # Decides if the custom font is to be initialized or not
		# (e.g. only load fonts once per CustomFontWidget chain)
    def borrow_or_set_font

      # Check if member of a CustomFontWidget hierarchy
			if @parent.is_a?(CustomFontWidget)

				# Borrow regular font from parent, set it
				self.setFont(@parent.font_regular)

				# For the other font styles, copy them from the parent
        font_related_instance_variable_names.each do |instance_var_s|
          parent_instance_var_equivalent = @parent.instance_variable_get(instance_var_s)
          instance_variable_set(instance_var_s.to_sym, parent_instance_var_equivalent)
        end

			else

				# Else, initialize and apply font
				initialize_and_apply_font
			end
    end
	
		# Initializer, creates the given fonts. The fonts
		# are hardcoded, since they are application-specific.
		def initialize_and_apply_font
			begin
			
				# Create new Font Database, if not already created
				@@font_db ||= Qt::FontDatabase.new

				# Retrieve font files
        prefix = @@settings[:typeface].downcase
        font_related_instance_variable_names.each do |instance_var_s|

          # Store symbol version for easy access
          instance_var_sym = instance_var_s.to_sym

          # Scrub the string, prepare filename e.g. @font_bold_italic => BoldItalic
          instance_var_s_clean = instance_var_s.sub("@font_", "")
          instance_var_s_filename = instance_var_s_clean.camelize.sub("_", "")

          # Set final resource path for the font, complete with filename and extension
          filename  = "#{@@settings[:typeface]}-#{instance_var_s_filename}.ttf"
          file_path = "#{@@settings[:font_path]}/#{filename}"

          # Check if the font file actually exists, skip if not found
          font_exists = File.exists?(file_path)
          next unless font_exists

          resource_with_filename =
            ":/#{prefix}/#{filename}"

          # Retrieve the actual font via the Qt Font Database
          retrieved_font = retrieve_font({
            :path  => resource_with_filename,
            :style => instance_var_s_clean.to_sym
          })

          # Set the instance variable to the proper value, apply font properties
          instance_variable_set(instance_var_sym, retrieved_font)
          apply_font_properties(retrieved_font)

          # Log outcome
          log.debug "#{instance_var_s} is:"
          log.info lpp instance_variable_get(instance_var_sym)
        end

				# Log font creation, shouldn't be more than once
        log.info "Custom Fonts loaded/initialized by #{@parent.class}"
				
				# Assign newly read font, regular by default. Other styles should be derived
				self.setFont(@font_regular)

      # Rescue any exception
			rescue Exception => e
				log.error e
			end		
		end
		
		# Utility method, retrieves a font using the given parameters
    #
		# Params: path  -- The resource path (!) to be used, e.g. ":/foo/bar/my_font.ttf"
    #
		#         style -- The style to be used, e.g. ":normal, :bold_italic" and so on [Optional]
		#         size  -- The size to be used, e.g. 8, 10 and so on [Optional]
		def retrieve_font(p_args)
			begin
			
				# Normalize arguments
				p_args[:style] ||= :normal
				p_args[:size]  ||= @@settings[:default_font_size]
			
				# Gather required font information
        log.info p_args[:path]
				id = @@font_db.addApplicationFont(p_args[:path])
				family_name = @@font_db.applicationFontFamilies(id).first
				
				# Create a font with the provided specifics
				result = @@font_db.font(family_name, p_args[:style].to_s.capitalize, p_args[:size])
				
				# Return result
				result

      # Rescue any exception
			rescue Exception => e
				log.error "Font retrieval failed, check resource paths (they unfortunately need to be hardcoded) !"
        log.error e
			end
    end

    # Utility method, checks for widgets which require a custom font, different
    # from their parent's (e.g. a different size)
    def apply_custom_font_styles

      begin

        # Only bother for MainWindows
        # TODO: ^Really?
        return unless @parent.is_a?(Qt::MainWindow)

        # Cache font-related instance variables
        loaded_fonts = font_related_instance_variables

        # Iterate through the children widgets
        @form.children_widgets.each do |child|

          # Retrieve associated instance variable
          alleged_widget = @form.instance_variable_get("@#{child.to_s}")

          # Skip non-Widgets
          next unless alleged_widget.is_a?(Qt::Widget)

          # Skip Widgets already using the loaded fonts (default size)
          current_font = alleged_widget.font
          next if loaded_fonts.include?(current_font)

          # Only proceed if the font family can be retrieved/derived
          # from the the FontDatabase
          available_font_families = @@font_db.families
          current_font_family = current_font.family
          if available_font_families.include?(current_font_family)

            # Derive new font variation
            derived_font = derive_font({
              :base  => current_font.weight,
              :style => current_font.style,
              :size  => current_font.pointSize
            })

            # If managed to successfully derive the font
            if derived_font.is_a?(Qt::Font)

              # Log event
              log.debug "Built tailor-made custom font :"
              log.debug lpp derived_font

              # Assign newly created font
              alleged_widget.font = derived_font

            end
          end

        end

      # Rescue any exception
      rescue Exception => e
        log.error e
      end

    end

    # Applies extra properties such as antialiasing to a given font.
    def apply_font_properties(p_font)
      p_font.setStyleStrategy(Qt::Font::PreferAntialias | Qt::Font::PreferQuality)
    end

end # class CustomFontWidget