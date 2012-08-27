# Class description
module Logging

  # Public declarations
  public

    # TODO: Use the parent property on Log4R::Logger to chain logs together, each 'parented' logger actually creates another logger instance!

    # Initialize loggers array
    @@loggers = {}

    # Add log4r
    require "log4r"
    require "log4r/formatter/log4jxmlformatter"
    include Log4r

    # Creates a new logger for the given including class,
    # placing it in the log folder.
    def self.included(p_class)
      self.create_log({
        :class => p_class
      })
    end

    # Shorthand for log4r's debug, warn, info [..] methods.
    # Meta-ing the methods resulted in wrong traces
    def self.[](p_class)
      @@loggers[p_class.class.name]
    end

    # Ultra shorthand for log4r's debug, warn, info [..] methods.
    # Injected within the including module. If provided, the suffix
    # should obviously match that used when created the alternate logger.
    def log(p_suffix = nil)
      key = (self.class.const_defined?(:LOGGING_PARENT) ? self.class.const_get(:LOGGING_PARENT).to_s : self.class.name)
      key += "#{Logging::add_suffix(p_suffix.to_s)}" unless p_suffix.nil?

      result = @@loggers.fetch(key, @@loggers[self.class.name])
      result = @@loggers.fetch(calling_class) unless result

      result
    end

    # Shorthand for a pretty printed log message, useful for Hashes, Arrays and so on.
    # Thanks to: http://extensions.rubyforge.org/rdoc/classes/Object.html#M000020
    def lpp(p_args)
      Logging::pretty_log(p_args)
    end

    # Creates an auxiliary log, with the given options (see create_log below)
    def log_create(p_args)
      Logging::create_log(p_args)
    end

    # Adds a generic debugging separator
    def lsep
      "=================================================================================="
    end

  # Private declarations
  private

    # Creates a log for the given class, level, optionally
    # adding a given suffix to the class
    #
    # Params: class -- the Class to create a log file for
    #
    #         level -- the logging level (Log4r::WARN for instance), ALL by default [Optional]
    #         append -- true if the log file is to be appended, false by default [Optional]
    #         prefix -- a prefix such as "ProjectName" to be inserted before the usual class name (or LOGGING_PARENT) [Optional]
    #         suffix -- a suffix such as "_local" to be appended to the usual class name (or LOGGING_PARENT) [Optional]
    #         chainsaw -- true if Apache Chainsaw integration is enabled (UDP, localhost:8071) [Optional
    def self.create_log(p_args)

      # Recalibrate arguments
      p_args[:level] ||= Log4r::ALL
      p_args[:append] = p_args[:append] || false
      p_args[:chainsaw] = p_args[:chainsaw] || false

      # Store including class' name
      class_name  = p_args[:class].name

      # Check if the currently to be instantiated logger
      # is to reside within another parent .log.xml file
      parent_log = p_args[:class].const_defined?(:LOGGING_PARENT) ? p_args[:class].const_get(:LOGGING_PARENT) : nil

      # Determine log file path
      target_class = parent_log.nil? ? class_name : parent_log
      target_class_name = target_class.to_s

      # Generate prefix and suffix, default to blank if not present
      prefix = add_prefix(p_args[:prefix]) || ""
      suffix = add_suffix(p_args[:suffix]) || ""

      # Add prefix and suffix to the file name, if present
      target_class_name = "#{prefix}#{target_class_name}#{suffix}"

      # Finalize log file path, logger name
      logger_file = "../log/#{target_class_name}.log.xml" # TODO: Fix relative path
      logger_name = "#{target_class_name}"

      # Create new log4r Logger, store in hash
      new_logger = Logger.new(logger_name)
      key = p_args[:suffix].nil? ? class_name : target_class_name.sub(prefix, "")
      @@loggers[key] = new_logger

      # Add XML file output capabilites to newly created logger, in Log4J Format
      file_out = Log4r::FileOutputter.new(logger_name, { :filename => logger_file, :trunc => !p_args[:append] })
      file_out.formatter = Log4jXmlFormatter.new
      new_logger.add(file_out)

      # Add Apache Chainsaw output capabilities to newly created logger, disabled by default
      if p_args[:chainsaw]
        require "log4r/outputter/udpoutputter"
        xml_formatter = Log4jXmlFormatter.new
        udp_out = UDPOutputter.new(logger_name, { :hostname => "localhost", :port => 8071 })
        udp_out.formatter = xml_formatter
        new_logger.add udp_out
      end

      # Set other logging options
      new_logger.trace = true
      new_logger.level = p_args[:level]
    end

    # Utility method, adds a prefix to a string
    def self.add_prefix(p_prefix)
      "#{p_prefix.to_s}-" unless p_prefix.nil?
    end

    # Utility method, adds a suffix to a string
    def self.add_suffix(p_suffix)
      "-#{p_suffix.to_s}" unless p_suffix.nil?
    end

    # Utility method, uses pp to log a given string
    def self.pretty_log(p_args)
      require "stringio"
      pps = StringIO.new
      PP.pp(p_args, pps)
      pps.string.chop
    end

end # class Logging