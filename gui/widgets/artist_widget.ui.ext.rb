# Load dependencies
require "widgets/extended/custom_font_widget"

# UI Extension for artist_widget.ui(.rb)
class ArtistWidgetExtUi < CustomFontWidget

	# Public declarations
	public
	
		# Parametrized constructor, initializes fields
		def initialize(p_form, p_parent)
			@form = p_form
			@parent = p_parent
			super(p_parent)
			
			# Initialize attributes
			@full_text = {}
			
			# Declare constants
			@@ellipse_chars = "[...]"
			
			@@max_length = {}
			@@max_length[:name] = 27 # characters
			@@max_length[:tags] = 25 # characters
		end
		
		# Overriden show event, sets bold font
		def showEvent(p_event)
      super(p_event)
			@form.artistName.font = @font_bold 
		end
		
		# Attribute getters, name and tags
		def name() @form.artistName.text; end
		def tags() @form.artistTags.text; end
		
		# Attribute setters, name and tags
		def name=(p_text) assign_text(p_text, :name); end
		def tags=(p_text) assign_text(p_text, :tags); end
						
		# Attribute setter override, picture
		def picture=(p_pic)
			map = Qt::Pixmap.new("C:/Users/Dr1Ku/Desktop/63111675.png")
			@form.picture.setPixmap(map)

		end
	
	# Private declarations
	private
	
		# Utility method, determines target of a set call
		def get_target(p_sym)
			p_sym == :tags ? @form.artistTags : @form.artistName
		end
		
		# Utility method, trims a String to a given length,
		# adding the full-length text as a tooltip.
		def trim(p_str, p_target, p_sym)
				
			# Store full text in instance var
			@full_text[p_sym] = p_str
			
			# Trim text, set tool tip
			p_str = "#{p_str.slice(0..@@max_length[p_sym] - @@ellipse_chars.length + 1)} #{@@ellipse_chars}"
			
			# Set tooltip
			p_target.setToolTip(@full_text[p_sym])
			
			# Return (trimmed) result
			p_str
		end
		
		# Utility method, assigns a text to a label, called via
		# a setter. Eventually trims the text before assigning.
		def assign_text(p_text, p_sym)
		
			# Determine target
			target = get_target(p_sym)
		
			# Trim excess text if necessary
			p_text = trim(p_text, target, p_sym) if p_text.length > @@max_length[p_sym]
					
			# Set text on target
			target.setText(p_text)
			
		end
				
end # class ArtistWidgetExtUi