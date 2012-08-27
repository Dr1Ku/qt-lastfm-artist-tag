# Load dependencies
require "widgets/extended/input_widget_notificator"

# A QLineEdit which displays a given help
# message until it receives focus. Rendered
# obsolute in Qt 4.7 with the addition of
# 'placeholderString' to QLineEdit.
class Qt::LineEditWithHint < Qt::LineEdit

	# Public declarations
	public

		# Slots declarations
		slots "enter_pressed()"
		
		# Parametrized constructor
		# Params: validate_callback -- A callback (lambda/Proc) which should return a bool. True if text is valid
		#         done_callback -- A callback (lamda/Proc), posted when the line edit is reverted to default (timeout)
		# 				warn_text -- The text to display when validation fails [Optional]
		#         text_color -- The color to use as a background when validation fails [Optional]
		def initialize(p_text, p_parent, p_args)
			super(p_text, p_parent)
			do_initialize(p_args)
		end	
		
		# Setter for current text, restore palette if needed
		def setText(p_text)
			super(p_text)
			self.palette = @palette_normal if self.palette == @palette_waiting
		end
		
		# Helper method, checks if the
		# currently displayed text is
		# the initial help text or not
		def has_actual_input?
			self.text != @help_text
		end		
		
		# Detect mouse clicks (another way of saying 'got focus'),
		# select all text if no other text selected, enabling paste
		def mousePressEvent(p_event)
			setSelection(0, self.text.length) if !self.hasSelectedText && p_event.button == Qt::LeftButton	
		end
		
		# Event handler, fired when focus is gained
		def focusInEvent(p_event)
			super(p_event)
			
			# Reset text and palette if needed
			do_reset if !@reset && self.text == @help_text			
		end		
		
		# Event handler, fired when a key is pressed.
		# Used in the event in which the user starts
		# typing immediately after the LineEdit is
		# displayed. Special handling occurs once.
		def keyPressEvent(p_event)

			# Execute the block only once
			if @initial_input_ready
			
				# Reset flag, assures single execution
				@initial_input_ready = false
				
				# Get focus, reset to normal state
				self.setFocus
				do_reset
			end
			
			# Bubble back to parent
			super(p_event)
		end
		
		# Utility event, to be called if input is
		# allowed straight after displaying the
		# edit. Grabs keyboard and braces for input
		def prepare_for_immediate_keypress
			@initial_input_ready = true
			self.setCursorPosition(0)
			self.grabKeyboard
		end
				
	# Private declarations
	private
	
		# Initializer. Called from regular constructor(s)
		def do_initialize(p_args)
			
			# Assign instance variables
			@help_text = self.text
			
			@validate_callback = p_args[:validate_callback]
			@done_callback = p_args[:done_callback]
						
			@warn_text = p_args[:warn_text]
			@warn_text ||= "Incorrect, try again."
			
			# Temporary constant, RGB value for a default shade of grey
			grey_shade = 175
			text_color = p_args[:text_color]
			text_color ||= Qt::Color.new(grey_shade, grey_shade, grey_shade)
			
			# Initialize attributes
			@notification = InputWidgetNotificator.new({
				:type => :warn, 
				:text => @warn_text, 
				:target => self,
				:done_callback => lambda { @done_callback.call unless @done_callback.nil? } # Post done callback
			})
			
			# Store normal palette
			@palette_normal = self.palette
					
			# Create and assign alternate palette (another text color, grey by default)
			@palette_waiting = Qt::Palette.new
			brush = Qt::Brush.new(text_color)
			brush.style = Qt::SolidPattern
			@palette_waiting.setBrush(Qt::Palette::Active, Qt::Palette::Text, brush)
			
			# Assign palette
			self.palette = @palette_waiting
			
			# Flag, keeps a tab on the current state (waiting/normal palette)
			@reset = false
			
			# Connect 'ENTER pressed' signal
			Qt::Object.connect(self, SIGNAL('returnPressed()'), self, SLOT('enter_pressed()'))
		end			
		
		# Enter pressed Event Handler, post callback (if any)
		def enter_pressed

      # Only proceed if a validation is provided
      unless @validate_callback.nil?

        # Call validation method, display notification if invalid
        result = @validate_callback.call(self.text)
        @notification.show unless result
      end
		end
		
		# Utility function, reverts the text and the palette to defaults
		def do_reset
		
			# Mark state as reset
			@reset = true
			
			# Revert text and palette
			self.text = nil 
			self.palette = @palette_normal			
		end
	
end # class LineEditWithHint