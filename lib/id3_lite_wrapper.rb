# Load dependencies
require "id3lib"

# Project dependencies
require "model/artist"
require "model/util/model_utils"

class ID3LiteWrapper

	# Public declarations
	public

    # Include log4r
    LOGGING_PARENT = :Model
    include Logging
		
		# Parametrised constructor, initializes fields
		def initialize(p_path)

			# The (absolute) path of the mp3 file, 
			# used to read ID3 Tag-related information
			@path = p_path
			
			# Initialize the tag, an ID3Lib::Tag instance (a ID3 v1.x/v2.y Tag)
			@tag = nil
		end
			
		# Adds the given (last.fm-retrieved) tags to the 
		# comment field of the mp3's ID3v2 Tag (otherwise known
    # as 'grouping' (iTunes) or 'contentgroup' (standard) )
		def add_tags_for(p_artist)
			begin

				# Check parameter
				return unless p_artist.is_a? Artist				
				
				# Temporary store tags for the given artist
				tags = p_artist.tags
				
				# Proceed only if there are tags to be added
				unless tags.empty?
									
					# Create separated list of tags
					tag_list = p_artist.tags.join(@@settings[:tag_separator])
					
					# Assign the new tags to the grouping (iTunes)
					# and genre (ID3 v2, Winamp) tag fields
					tag.grouping = tag_list
					tag.genre = tag_list
					
					# Update the ID3 Tag
					tag.update!
				end
			
			# Rescue any exceptions
			rescue Exception => e 
				log.error e
			end			
    end

    # Utility methods, sanitizes all used tags
    def sanitize!
      begin

        # Sanitize newly read Tags
        @@settings[:tag_fields].each do |tag_field|
          field = tag_field.to_s
          field_value = send("#{field}")
          send("#{field}=", ModelUtils::id3_sanitize(field_value))
        end

      # Rescue any exceptions
      rescue Exception => e
        log.error e
      end
    end

    # Utility method, checks if a tag was unreadable / undefined
    def empty?
      tag.empty?
    end
			
	# Private declarations
	private

    # Initialize settings. Not in the initializer, since
    # it is called by the class macro before.
    # (See 'use_tag_fields' method call below)
    @@settings = {

      # Set the separator for multiple
      # tags -- will be written in the ID3
      # 'comments' field for the given mp3
      :tag_separator => ' ',

      # Set which ID3 v1.x/v2.y fields can be read and written
      :tag_fields => [:artist, :album, :year, :grouping, :genre]

    }.freeze

		# Use tag fields class macro
		def self.use_tag_fields(*p_args)
      p_args.flatten!
			p_args.each do |current_arg|
			
				# Define public getter
        public
          define_method("#{current_arg}") do
            tag_get(current_arg)
          end
			
				# Define private setter
				private
					define_method("#{current_arg}=") do |setter_argument|
						tag_set(current_arg, setter_argument)
					end
				
			end
    end

  require 'ruby-debug'
		
		# Wrapper for tag getters/setters
		def tag_set(p_tag_sym, p_val) tag.send("#{p_tag_sym.to_s}=", p_val) end
		def tag_get(p_tag_sym) 			  tag.send("#{p_tag_sym.to_s}") end
		
		# ID3 v1/v2 used tag fields
		use_tag_fields @@settings[:tag_fields]
		
		# Custom getter for ID3 Tag, 
		# read on demand, only once
		def tag
			begin

				# Retrieve ID3 Tag if not yet read
				@tag = ID3Lib::Tag.new(@path) if @tag.nil?

        # Return result
        @tag

			# Rescue any exceptions
			rescue Exception => e 
				log.error e
			end
    end

end # class ID3LiteWrapper