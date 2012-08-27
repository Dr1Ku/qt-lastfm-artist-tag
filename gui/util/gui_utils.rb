class GuiUtils

	# Centers a given widget within a given 'parent' widget
  #
  # Params: widget -- The widget to be centered
  #         parent -- The parent widget in which the given widget is to be centered
  #
  #         append_to_position -- True by default, set to false if the calculated center
  #                               position is to be applied to the to be centered widget's position
  #
  #         pixel_diff -- An Array, containing [x,y] coordinates to append to the calculated center (Optional)
	def self.center_relative_to(p_args)

    # Recalibrate parameters
    p_args[:pixel_diff] ||= [0, 0]
    p_args[:append_to_position] = true if p_args[:append_to_position].nil?

		# Repaint the target widget to get updated size readings
		p_args[:widget].repaint

		# Compute current width and height of the parent widget
		current_width  = p_args[:parent].width
		current_height = p_args[:parent].height
		
		# Calculate values needed to bring the sent widget to the center of the parent
		move_x = current_width  / 2 - p_args[:widget].width  / 2 + p_args[:pixel_diff][0]
		move_y = current_height / 2 - p_args[:widget].height / 2 + p_args[:pixel_diff][1]
			
		# Eventually add the computed values to the current position
		if p_args[:append_to_position]
			current_position = p_args[:parent].pos
			move_x += current_position.x
			move_y += current_position.y
		end
		
		# Finally, move the given widget
		p_args[:widget].move(move_x, move_y)
	end
	
	# Creates a child form, which is placed within a blank widget.
	# Remember to override closeEvent, calling parentWidget.close !
  #
	# Params: class -- The Ui_<foo> class to construct
	#				  flags -- The WindowFlags of the new widget
	#         position -- The Position of the new widget
  #
  #         extra_params -- The extra paramaters to eventually pass to constructor [Optional]
	#         base_widget -- The widget to be used for layout, falls back to blank widget if nil [Optional]
	#         show -- If false, doesn't show form immediately. Default true [Optional]
	def self.create_child_form(p_args)
	
		# Recalibrate parameters
		p_args[:base_widget] ||= Qt::Widget.new
		p_args[:show] = true if p_args[:show].nil?
    p_args[:flags] ||= Qt::Window
	
		# Create form from given class name, eventually with parameters
    ui_instance = p_args[:extra_params].nil? ? p_args[:class].new : p_args[:class].new(p_args[:extra_params])
		
		# Create blank widget, eventually set window type
		base_widget = p_args[:base_widget]
		base_widget.setWindowFlags(p_args[:flags]) unless p_args[:flags].nil?
				
		# Setup and translate UI
		ui_instance.setupUi(base_widget)
		ui_instance.retranslateUi(base_widget)
				
		# Eventually move the child form to a given [x,y] position, show child form
		base_widget.move(p_args[:position][0], p_args[:position][1]) unless p_args[:position].nil?
		base_widget.show if p_args[:show]
		
		# Return newly created child form and Ui_<foo> instance
		{ :form => base_widget, :ui => ui_instance }
	end
	
	# Utility method, replaces a given item within a grid.
  #
	# Params: grid -- The grid to use
	#         old_widget -- The widget to remove 
	#         new_widget -- The widget to add
  #
	#					row -- The row to add the new widget at [Optional, default 0]
	#         col -- The column to add the new widget at [Optional, default 0]
  #
	#         row_span -- The row span to use for the new widget [Optional]
	#         col_span -- The column span to use for the new widget [Optional]
	def self.replace_grid_widget(p_args)

		# Get grid
		grid = p_args[:grid]
		
		# Recalibrate arguments
    p_args[:row] ||= 0
    p_args[:col] ||= 0
		p_args[:row_span] ||= 1
		p_args[:col_span] ||= 1

		# Out with the old, in with the new
		p_args[:old_widget].hide
		grid.removeWidget(p_args[:old_widget])
		grid.addWidget(p_args[:new_widget],
       p_args[:row], p_args[:col],
       p_args[:row_span], p_args[:col_span]
    )
	end
	
	# Utility method, adds new roles to a given palette, using the given color to 
	# construct a solid brush. If the given palette is nil, a new one is created.
  #
	# Params: color -- The color to use for the brush
  #
  #         palette -- The palette to use (will be created if not given) [Optional]
	#         style -- The brush style to use [Optional]
	#         role -- The role to apply the color for [Optional]
	#         groups -- The ColorGroup s to apply the brush to [Array] [Optional]
	def self.add_to_palette(p_args)
		
		# Retrieve palette, create if not supplied
		palette = p_args[:palette]
		palette ||= Qt::Palette.new
		
		# Retrieve style, fallback to default if not supplied
		style = p_args[:style]
		style ||= Qt::SolidPattern
		
		# Create a brush with the given style, fallback if not provided
		brush = Qt::Brush.new(p_args[:color]) do |new_brush|
			new_brush.style = style
		end
		
		# Retrieve groups (inactive, active or disabled), fallback if not provided
		groups = p_args[:groups]
		groups ||= [Qt::Palette::Active, Qt::Palette::Inactive]
		
		# Retrieve role, fallback if not provided
		role = p_args[:role]
		role ||= Qt::Palette::Window
		
		# Set Brush for each group
		groups.each do |group|
			palette.setBrush(group, role, brush)
		end
		
		# Return created palette
		palette
  end

  # Utility method, creates or activates a child Form, given a variable
  # which may store an already created form (=> the effect will be:
  # form will be activated) or nil (=> the effect will be: the form
  # will be created and then activated).
  #
  # Params: state_var -- The variable which will receive the child form
  #         args -- The params to be passed to GuiUtils.create_child_form
  def self.activate_or_create_child_form(p_state_var, p_args)

    # Only create child form if not already created
    if p_state_var.nil?
      result = GuiUtils.create_child_form(p_args)
      p_state_var = result[:form]
    end

    # Show and activate child form
    p_state_var.show
    p_state_var.activateWindow

    # Return result (created or already available child form)
    p_state_var
  end
	

end
