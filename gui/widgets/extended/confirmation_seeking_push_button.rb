# Project dependencies
require "widgets/extended/timed_object"

require "util/gui_utils"
require "util/colors"

# An extension of a Qt::PushButton which requires a
# user confirmation before its pressd signal is issued.
# A timer is used to reset the button's state if the
# action has not been confirmed. Useful for delete actions, 
# for instance.
class ConfirmationSeekingPushButton < Qt::PushButton

	# Public declarations
	public

    # Include timer-based actions
    include TimedObject
	
		# Slot declarations
		slots "was_clicked()"
		
		# Parametrized constructor, initializes fields
		def initialize(p_warn_icon, p_warn_text, p_parent, p_validate_callback)
			super(p_parent)

      # Initialize timer
      initialize_timer
			
			# Initialize attributes and their initial values
			@initial_icon = self.icon
			@warn_icon = p_warn_icon
			
			@initial_text = self.text
			@warn_text = p_warn_text
			
			# The validate callback should internally 
			# confirm that the element which is to be
			# deleted is the same as the one for which
			# the confirmation was issued in the first
			# place. Actual deletion is not a concern
			# of this class. If confirmed, the was_confirmed
			# method should be called.
			@validate_callback = p_validate_callback
			
			# Call the initializer 
			do_initialize
		end
		
		# Utility method, used from the outside to
		# manually reset the internal timer, usually
		# called when the delete action was confirmed,
		# so that the background is reset as quick as
		# possible.
		def was_confirmed
			stop_timer
		end
		
		# Event Handler, fired when any event is posted.
		# However, only treats ShortcutEvents. The same
		# functionality as a EventFilter on the parent I guess
		def event(p_event)
			super(p_event)
					
			# Also provide the same click-like behaviour for shortcut use
			if p_event.is_a?(Qt::ShortcutEvent)
			
				# The button remains down until 'handled' in some way,
				# a small hack is to set the down state to false
				self.setDown(false)
				
				# Emit the signal for a regular click
				emit clicked
			end
			
		end	# event
					
	# Private declarations
	private
		
		# Proper initializer, called by other constructor(s)
		def do_initialize
		
			# Initialize background color-related properties
			initialize_palette
		
			# Initialize constants
      @timer_duration = 3 # seconds

			# Initialize attributes
			@awaiting_confirmation = false

			# Connect click signal to self
			Qt::Object.connect(self, SIGNAL('clicked()'), self, SLOT('was_clicked()'))
		end
		
		# Initializes the necessary items for a background color
		def initialize_palette
		
			# Store initial palette
			@initial_palette = self.palette
			@warn_palette = Qt::Palette.new
		
			# Prerequisite properties
			self.setBackgroundRole(Qt::Palette::Button)
			
			# Construct brush and add to palette, use a orange-y warn color
			GuiUtils.add_to_palette({
				:palette => @warn_palette,
				:color => Colors.notify_warn(nil),
				:role => Qt::Palette::Button
			})			
		end
		
		# Event Handler, fired when the wait period for the confirmation
		# has elapsed. Stops the timer and modifies the background (normal state)
		def stop_timer

      # Call base module handler
      super

      # Reset state
			@awaiting_confirmation = false
			set_warn_state(false)
		end
				
		# Event Handler, fired when the button was clicked/activated, handles
		# the event based upon the current state (awaiting confirmation or not).
		def was_clicked
				
			# Check if the received click is a confirmation or a regular click
			if @awaiting_confirmation

				# Forward event to validator, if defined
				@validate_callback.call if @validate_callback.is_a?(Proc)

      else

				# Change flag
				@awaiting_confirmation = true
			
				# Modify background, warn state
				set_warn_state(true)
		
				# Start the timer
				start_timer
			end
		
		end		
		
		# Utility method, modifies button properties depending on the passed parameter
		def set_warn_state(p_is_warn_state)
			
			# Set text and icon
			self.text = p_is_warn_state ? @warn_text : @initial_text
			self.icon = p_is_warn_state ? @warn_icon : @initial_icon
			
			# Set background
			self.flat = p_is_warn_state
			self.autoFillBackground = p_is_warn_state
			self.palette = p_is_warn_state ? @warn_palette : @initial_palette
		end

end