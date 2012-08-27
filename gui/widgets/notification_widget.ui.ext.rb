# Project dependencies
require "widgets/extended/custom_font_widget"
require "widgets/extended/timed_object"

require "util/gui_utils"
require "util/colors"

# UI Extension for notification_widget.ui(.rb)
class NotificationWidgetExtUi < CustomFontWidget

	# Public declarations
	public

    # Include timer-based actions
    include TimedObject

		# Parametrized constructor, initializes fields
		def initialize(p_form, p_parent)
			@form = p_form
			@parent = p_parent
      super(p_parent)

      # Initialize timer
      initialize_timer

      # Initialize attributes
      @self_destruct_callback = nil
			
			# Initialize notification types
			@@notification_types = Colors.notification_types
			
			# Initialize resource paths
			resource_path = ":/root/images/notify"
			@@notification_icons = {
				:ok    => "#{resource_path}/tick-circle-frame.png",
				:info  => "#{resource_path}/information-frame.png",
				:warn  => "#{resource_path}/exclamation--frame.png",
				:error => "#{resource_path}/cross-circle-frame.png"
			}
		end
		
		# Setter for 'type', e.g. what kind of a notification is presented. 
		# Assigns colors and icons to the widgets
		def type=(p_type)

			# Verify parameter
			unless @@notification_types.include?(p_type)
				puts "NotifyWidgetExtUi::type= -- ERROR: Only use one of [#{types.join(',')}] as an argument !"
				return
      end

      # Only change icon if different from current icon
      return if @form.statusIcon.pixmap.eql?(@@notification_icons[p_type])

			# Request background and dark color from catalogue
			color_back = Colors.send("notify_#{p_type.to_s}", :back)
			color_dark = Colors.send("notify_#{p_type.to_s}", :dark)
			
			# Create palette for label and icon, assign
			palette_label_icon = GuiUtils.add_to_palette({ :color => color_back })

			@form.statusIcon.setPalette(palette_label_icon)
			@form.statusLabel.setPalette(palette_label_icon)
			
			# Create palette for line, darker color, assign
			palette_line = GuiUtils.add_to_palette({ :color => color_dark, :role => Qt::Palette::WindowText })
			@form.emphasisLine.setPalette(palette_line)
			
			# Load icon if not yet retrieved
			if @@notification_icons[p_type].is_a?(String)
				@@notification_icons[p_type] = Qt::Pixmap.new(@@notification_icons[p_type])
      end

      # Set icon
      @form.statusIcon.setPixmap(@@notification_icons[p_type])
		end
		
		# Setter for 'text', e.g. what message to display within the notification
		def text=(p_text)
			@form.statusLabel.setText(p_text)
    end

    # Setter, used to make the notification disappear after
    # a given number of seconds
    def vanish_after(p_duration = nil, p_self_destruct_callback = nil)

      # Set self-destruct attributes, if available
      unless p_duration.nil?
        @timer_duration = p_duration
        @self_destruct_callback = p_self_destruct_callback
      end

      # Start timer
      start_timer
    end
		
	# Private declarations
	private

    # Overriden event handler, fired when the timer has stopped
    def stop_timer

      # Call base module handler
      super

      # Engage auto destruct sequence, post callback if needed
      self.destroy
      @self_destruct_callback.call unless @self_destruct_callback.nil?
    end
	
end # class NotifyWidgetExtUi