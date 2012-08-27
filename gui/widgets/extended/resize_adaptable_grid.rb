# A GridLayout which hosts a number of fixed-size
# items, resizing the number of items displayed
# depending on the size of the parent
class ResizeAdaptableGrid < Qt::GridLayout

  # Public declarations
  public

      # Include log4r
      LOGGING_PARENT = :MainWindowExtUi
      include Logging

      # Parametrized constructor, initializes the grid's attributes
      # Params: parent -- the Parent Widget that will house the grid
      #         item_width  -- The width  of *all* items to be stored within the grid
      #         item_height -- The height of *all* items to be stored within the grid
      def initialize(p_args)

        # Store the parent
        @parent = p_args[:parent]
        super(@parent)

        # Initialize attributes
        @space_available = {}
        @widgets = []
        @row_count = -1
        @column_count = -1

        # Initialize GUI attributes
        self.sizeConstraint = Qt::Layout::SetMinAndMaxSize
        self.margin = 4
        self.horizontalSpacing = 4
        self.verticalSpacing = 0
        #self.setContentsMargins(0)

        # Store item size
        @item_size = { :width => p_args[:item_width], :height => p_args[:item_height] }

        # Return result
        self
      end

      def parent_resized
        total_space = compute_available_space
        rearrange(total_space)
      end

      def add_widget(p_widget)

        compute_available_space

        # Add to grid, store in array
        add_to_grid(p_widget)
        @widgets << p_widget
      end

  # Private declarations
  private

    def add_to_grid(p_widget)

      # Verify column overflow
      next_column = @column_count + 1
      if next_column >= @space_available[:cols]
        @row_count += 1
        next_column = 0
      end

      # Verify row overflow
      next_row = @row_count + 1
#      if next_row >= @space_available[:rows]
#        p_widget.hide
#      end

      self.addWidget(p_widget, next_row, next_column, 1, 1)

      # Update column and row counts
      @column_count = next_column

    end

    def get_visible_widgets

      visible_widgets = @widgets.select { |widget| widget.isVisible }
      visible_widget_count = visible_widgets.length unless visible_widgets.empty?
      visible_widget_count ||= 0

      { :count => visible_widget_count, :contents => visible_widgets }
    end

    def compute_available_space
      current_size = @parent.parent.parent.size

      visible_widget_count = get_visible_widgets[:count]

      actual_width  = current_size.width  - (visible_widget_count * self.horizontalSpacing)
      actual_height = current_size.height - (visible_widget_count * self.verticalSpacing)

      pp "W x H: #{actual_width}(#{current_size.width}) x #{actual_height}(#{current_size.height})"

      col_count = (actual_width.to_f  / @item_size[:width]).round
      row_count = (actual_height.to_f / @item_size[:height]).round

      pp "Rows x cols : #{row_count} x #{col_count}"

      new_space = { :cols => col_count,
                    :rows => row_count }

      if @space_available.empty?
        @space_available = new_space
      elsif new_space[:rows] < 5
        increased = (new_space[:rows] >= @space_available[:rows] + 1)
        decreased = (new_space[:rows] <  @space_available[:rows])

        @space_available = new_space if increased ^ decreased
      else

        if new_space[:rows] == 4
          increased = (new_space[:cols] >= @space_available[:cols] + 1)
          decreased = (new_space[:cols] <  @space_available[:cols])

          @space_available = new_space if increased ^ decreased
        end

      end

      total_space = @space_available[:rows] * @space_available[:cols]
      total_space
    end

    def rearrange(p_total_space)

      visible_widgets_count = get_visible_widgets[:count]

      if p_total_space > visible_widgets_count
        set_widget_visibility({ :count => p_total_space })
      else
        to_hide_count = visible_widgets_count - p_total_space
        return if to_hide_count == 0

        set_widget_visibility({
          :count => to_hide_count,
          :increment => p_total_space,
          :hide => true
        })
      end
    end

    def set_widget_visibility(p_args)

      # Check parameters
      return if p_args[:count].nil?

      # Recalibrate arguments
      p_args[:increment] ||= 0
      p_args[:hide] = p_args[:hide] || false

      p_args[:count].times do |current_index|
        current_widget = @widgets[current_index + p_args[:increment]]
        next if current_widget.nil?

        current_widget.show if !p_args[:hide] && !current_widget.isVisible
        current_widget.hide if  p_args[:hide] &&  current_widget.isVisible
      end

    end

end # class ResizeAdaptableGrid