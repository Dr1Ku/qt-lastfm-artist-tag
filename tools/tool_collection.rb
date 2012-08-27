# Project dependencies
require "widgets/tool_description_widget.ui"

# A collection of all the tools available,
# ready to be plugged into the GUI.
class ToolCollection

  # Public declarations
  public

    # Include log4r
    include Logging

    # Constructor, initializes fields
    def initialize(p_tools_form)
      @tools_form = p_tools_form
      initialize_tools
    end

    # Public tool accessor
    def get_tool(p_key)
      create_container_and_configuration(@tools[p_key]) if @tools.has_key?(p_key)
    end

  # Private declarations
  private

    #                            #
    # Actual Tool Configurations #
    #                            #
    def initialize_tools

      # Main tool collection
      @tools = {

        :aggregate => {

          :tool_title => "Aggregate - Consolidate artist's albums",
          :tool_execute_handler => lambda { puts "zz" },
          :tool_description => <<-AggregateDescription
            This tool takes in a random collection of *properly tagged* mp3 albums
            (stored within folders) and aggregates each artist's albums into
            a new folder, non-album tracks included. The example to the left provides a
            glimpse into the functionality: given a path containing mp3 albums,
            it consolidates the collection by grouping albums from each artist
            into a folder named accordingly - each artist in one and one folder only.
          AggregateDescription
        }

      }.freeze

      # Sensible defaults
      @tools.each_key do |key|
        @tools[key].store(:tool_image_path, "#{key.to_s}.png")
      end

    end

    # Wrapper for the GUI tool creation process
    def create_container_and_configuration(p_args)

      # Create container
      tool_container = GuiUtils.create_child_form({
				:class => Ui_ToolDescriptionWidget,
        :flags => 0,
				:base_widget => CustomFontWidget.new(@tools_form),
			})

      # Create configuration
      tool_config = ToolConfiguration.new(p_args)

      # Return results
      { :container => tool_container, :config => tool_config }
    end

end # class ToolCollection