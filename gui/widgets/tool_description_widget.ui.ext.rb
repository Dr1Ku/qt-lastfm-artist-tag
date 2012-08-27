# Project dependencies
require "widgets/extended/custom_font_widget"

# UI Extension for tool_description_widget(.ui)
class ToolDescriptionWidgetExtUi < CustomFontWidget

	# Public declarations
	public

    # Parametrized constructor, initializes fields
		def initialize(p_form, p_parent)
			@form = p_form
			@parent = p_parent
      super(p_parent)

      # Initialize attributes
      @@settings = nil
      @configuration = nil
    end

    # Setter for tool_title, updates the form
    def set_configuration(p_config)

      # Update local field
      @configuration = p_config

      # Set title and description
      @form.toolTitle.text = @configuration.tool_title
      @form.toolDescription.text = @configuration.tool_description

      # Set image, prepend resource root to the given resource path
      @configuration.tool_image_path =
        "#{@@settings[:tool_resource_root]}/#{@configuration.tool_image_path}"

      # Create a Pixmap and set it to the icon placeholder
			new_pixmap = Qt::Pixmap.new(@configuration.tool_image_path)
      @form.toolImage.setPixmap(new_pixmap)
    end

    # GUI Helper method, sets the frame image
    # according to the passed parameter
    def toggle_frame_image(p_enable)

      # Assign a pixmap to the frame image,
      # depending on the passed parameter
      key = p_enable ? :hover : :normal
      pixmap = @@settings[:frame_images][key]
      @form.toolShadowFrame.setPixmap(pixmap)
    end

    # GUI Event Handler, called when the image is clicked.
    # Forwards the event to the actual handler, as specified
    # by this tool's configuration.
    def handle_click
      handler = @configuration.tool_execute_handler
      handler.call unless handler.nil?
    end

    # Overriden show event, initializes some needed runtime components
    def showEvent(p_event)

      # Runtime initializer
      if @@settings.nil?

        # Initialize constants
        @@settings = {

          # Root path of all tool resources
          :tool_resource_root => ":/root/images/tools",

          # Frame images
          :frame_images => {
            :normal => Qt::Pixmap.new(":root/images/frames/toolFrame.png"),
            :hover  => Qt::Pixmap.new(":root/images/frames/toolFrameHover.png")
          }

        }.freeze

        # Set normal frame per default
        toggle_frame_image(false)

        # Inject generic GUI Handlers to the tool image
        @form.toolImage.instance_eval <<-EventHandlerInject

          # Gets the UI Extension Class for a given UI Element
          def get_ui_extension(p_object_name)

            # Move up the visual tree to get the parent widget ('window' / frame)
            current_parent = self.parent
            until current_parent.objectName.eql?(p_object_name)
              current_parent = current_parent.parent
              return if current_parent.nil?
            end

            # Get the extended UI Class
            current_parent.children.first
          end

          # GUI Event Handler, fired when hovered
          def enterEvent(p_event)
            @ui_extension ||= get_ui_extension("toolDescriptionWidget")
            @ui_extension.toggle_frame_image(true)
          end

          # GUI Event Handler, fired when exited
          def leaveEvent(p_event)
            @ui_extension ||= get_ui_extension("toolDescriptionWidget")
            @ui_extension.toggle_frame_image(false)
          end

          # GUI Event Handler, fired when clicked
          def mousePressEvent(p_event)
            @ui_extension ||= get_ui_extension("toolDescriptionWidget")
            @ui_extension.handle_click
          end

        EventHandlerInject
      end

    end

	# Private declarations
	private

end # class ToolDescriptionWidgetExtUi