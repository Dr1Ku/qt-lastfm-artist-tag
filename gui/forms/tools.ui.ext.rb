# Load dependencies
require "tools/tool_configuration"

# UI Extension for Tools.ui
class ToolsExtUi < Qt::Widget

  # Public declarations
  public

    # Include log4r
    LOGGING_PARENT = :MainWindowExtUi
    include Logging

    # Parametrized constructor, initializes fields based
    # on the given parameters (associated form and its parent)
    def initialize(p_form, p_parent)

      # Call base class constructor
      super(p_parent)

      # Initialize form and parent
      @form = p_form
      @parent = p_parent

      # Initialize attributes
      @tools = []
    end

    # Initializes and adds a given tool to the tool palette
    def initialize_and_add_tool(p_args)

      # Check arguments
      return unless p_args.is_a?(Hash) && p_args.has_keys?(:container, :config)

      # Update the configuration on the tool's UI
      widget_hash = p_args[:container]
      tool_config = p_args[:config]
      widget_hash[:ui].extension.set_configuration(tool_config)

      # Add the tool to the collection and the form
      tool_count = @tools.length
      @tools << { :widget => widget_hash, :config => tool_config }
      @form.gridLayout.addWidget(widget_hash[:form], tool_count, 0, 1, 1)
    end

  # Private declarations
  private

end # class ToolsExtUi
