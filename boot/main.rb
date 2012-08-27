# General depedencies
require "pp"

# Load gem bundle
begin
  require "bundler/setup"

rescue LoadError
  require "rubygems"
  require "bundler/setup"
end

# Add global logging and debugging capabilities.
# To create a log for a Class: include Logging
# To debug a given line: require 'ruby-debug' and call 'debugger'
require "util/logging"
require "ruby-debug-base"

# Special-purpose extensions and utils, project-specific settings
require "boot/extensions"
require "boot/utils"

require "boot/consts"