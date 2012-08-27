# Simple wrapper for the configuration entity
# of a tool, contains the necessary information
# for display and execution
class ToolConfiguration

  # Public declarations
  public

    # Publicly accessible attributes
    attr_accessor :tool_title, :tool_description, :tool_image_path,
                  :tool_execute_handler

    # Default constructor, initializes fields.
    # Args should have the same keys as the attributes.
    def initialize(p_args)

      # Check arguments
      return unless p_args.is_a?(Hash) &&
                    p_args.has_keys?(:tool_title, :tool_description, :tool_execute_handler)

      # Assign attributes
      @tool_title = p_args[:tool_title]
      @tool_description = p_args[:tool_description].gsub(/[\n]+ {3,}/, " ").gsub(/ {3,}/, "")
      @tool_image_path = p_args[:tool_image_path]
      @tool_execute_handler = p_args[:tool_execute_handler]
    end

end # class ToolConfiguration