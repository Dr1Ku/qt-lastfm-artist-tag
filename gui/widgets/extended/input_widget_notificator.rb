# Project dependencies
require "widgets/extended/timed_object"
require "util/colors"

# Utility class for setting a InputWidget (a Qt::LineEdit for instance)
# 's background color and text, with the goal of notifying a user that
# the newly inserted input is wrong for instance. The given message is
# printed for a small window of time; afterwards the state of the widget
# (text, background color) is reverted to its former values.
class InputWidgetNotificator < Qt::Object

	# Public declarations
	public

    # Include timer-based actions
    include TimedObject
	
		# Parametrised constructor, initializes fields
		# Params: type -- The type of notification, one of [:ok, :info, :warn, :error]
		#         text -- The text to display
		#         target -- The InputWidget (usually a Qt::Label or Qt::LineEdit) in which the notification will be displayed
		#         done_callback -- Callback, posted when the state of the target is reset [Optional]
		def initialize(p_args)
			super(p_args[:target])

      # Initialize timer
      initialize_timer
		
			# Initialize notification types
			@@types = Colors.notification_types
			
			# Check type parameter
			unless @@types.include?(p_args[:type])
				puts "InputWidgetNotificator::initialize -- ERROR: Please use one of [#{@@types.join(",")}] as :type !"
				return
			end
			
			# Assign instance var from parameters
			@text = p_args[:text]
			@target = p_args[:target]
			@type = p_args[:type]
			@done_callback = p_args[:done_callback]
			
			# Initialize palettes container
			@palettes = {}
			
			# Initialize individual palettes (background colors)
			@@types.each do |type|
				initialize_palette(type, Colors.send("notify_#{type}",:back))
			end
		end
		
		# Main entry point, shows the given message with the given color
		# within the given target Widget (QLineEdit for instance) for the
		# specified time frame (duration).
		def show
			
			# Store former palette and text for quick reverting
			@former_palette = @target.palette
			@former_text = @target.text
			
			# Set text and palette
			@target.setText(@text)
			@target.palette = @palettes[@type]

			# Start the timer, release keyboard
			start_timer
			@target.releaseKeyboard
		end
		
	# Private declarations
	private
	
		# Utility initializer method
		def initialize_palette(p_type, p_color)
			brush = Qt::Brush.new(p_color)
			@palettes[p_type] = Qt::Palette.new
			@palettes[p_type].setBrush(Qt::Palette::Active, Qt::Palette::Base, brush)			
		end
		
		# Event Handler, fired when the notification time has elapsed,
		# resets text and background color
		def stop_timer

      # Call base module handler
			super
			
			# Reset palette and text
			@target.palette = @former_palette
			@target.setText(@former_text)
			
			# Post done callback
			@done_callback.call unless @done_callback.nil?
		end

end