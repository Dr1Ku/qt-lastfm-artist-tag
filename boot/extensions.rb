# This file contains special-purpose extensions to standard Ruby classes

# String extensions
class String

	# Source: http://apidock.com/rails/Inflector/camelize
	# File activesupport/lib/active_support/inflector.rb, line 160
  def camelize
		self.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
  end

end

# Small extensions to the Kernel
module Kernel

  # Gets the calling class, based on
  # http://snippets.dzone.com/posts/show/2787
  def calling_class
    if /^(.+?):(\d+)(?::in `(.*)')?/ =~ caller[1]
      File.basename(Regexp.last_match[1]).sub(".rb", "").camelize
    end
  end

end

# Extensions to Hash
class Hash

  # Test if a given hash contains the passed keys
  def has_keys?(*p_syms)
    p_syms.each do |sym|
      return false unless self.has_key?(sym)
    end
    true
  end

end