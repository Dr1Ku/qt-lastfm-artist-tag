# String extensions
class String

	# Source: http://apidock.com/rails/Inflector/camelize
	# File activesupport/lib/active_support/inflector.rb, line 160
  def camelize
		self.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end
end

# Main Class, generates files required for the
# Qt4Ruby - QtDesigner fix: a UI Extension Class
# and a Configuration File.
class Qt4RubyQtDesignerGenerator

  # Public declarations
  public

    def initialize
      @path = ARGV[0]
      @path_camel = File.basename(@path).camelize
      @path_camel_normal = @path_camel.sub(".ui", "")
    end

    # Public alias
    def run
      generate
    end

  # Private declarations
  private

    # Utility method to write a given string to a file
    def write_to(p_path, p_contents)
      file = File.new(p_path, "w")
      file.puts p_contents
      file.close
    end

    # Generates the UI Extension Class
    def generate_ext_ui

      # File contents
      ext_ui =
        <<-EXT_UI
# UI Extension for #{@path_camel}
class #{@path_camel_normal}ExtUi < Qt::Widget

  # Public declarations
  public

    # Parametrized constructor, initializes fields based
    # on the given parameters (associated form and its parent)
    def initialize(p_form, p_parent)

      # Call base class constructor
      super(p_parent)

      # Initialize form and parent
      @form = p_form
      @parent = p_parent

    end

  # Private declarations
  private

end # class #{@path_camel_normal}ExtUi
        EXT_UI

      # Write to file
      path = "#{@path}.ext.rb"
      write_to(path, ext_ui)

      # Output
      puts "Wrote UI Extension Class to '#{path}' ."
    end

    # Generates a Configuration File
    def generate_cfg

      class_name_lower_camel = @path_camel_normal
      class_name_lower_camel[0] += 32

      # File contents
      cfg =
        <<-CFG
[#{class_name_lower_camel}Form]
Handler = #{File.basename(@path)}.ext.rb
ClassName = #{class_name_lower_camel[0] -= 32; class_name_lower_camel}ExtUi

# Sample SigSlots:
# SigSlot = someButton,'clicked()',#{class_name_lower_camel},'some_button_was_clicked()'
# SigSlot = otherWidget,'other_widget_event(int, QDialog*)',#{class_name_lower_camel}, 'handle_this_event(int, QDialog*)'
        CFG

      # Write to file
      path = "#{@path}.cfg"
      write_to(path, cfg)

      # Output
      puts "Wrote Configuration File to '#{path}' ."
    end

    # Main entry point
    def generate

      # Generate UI Extension source file and Configuration File
      generate_ext_ui
      generate_cfg

      puts "\nDone."

    end # generate

end

# Main entry point
def main

  # Mandatory header ^_^
  header =
    <<-HEADER

qt4-fix Generator (http://github.com/Dr1Ku/qt4-qtruby-qtdesigner-integration)
-------------------------------------------------------------------------------------
Purpose: Generates files for an allegedly better QtDesigner - Qt4-QtRuby integration,
         e.g. a configuration file and a 'UI Extension' Class, given an UI File,
         created using the Qt Designer.

         Visit GitHub for more information (link above)
         Created by Dr1Ku (http://bit.ly/dr1ku)
-------------------------------------------------------------------------------------

    HEADER
  puts header

  # Normalize arguments
  ARGV[0] ||= ""

  # Check arguments, should match *.ui
  unless ARGV[0].end_with?(".ui")
    usage =
      <<-USAGE
      Usage: qt-fix-gen <My QtDesigner UI File>.ui
      USAGE

    puts usage
    exit -1
  end

  # Create generator and run
  Qt4RubyQtDesignerGenerator.new.run

end

# Call main method
main