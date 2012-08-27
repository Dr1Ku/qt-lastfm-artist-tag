# Load dependencies
require "model/util/model_utils"
require "util/file_system_utils"

# An artist represents a musical group, storing
# albums within the user's musical collections.
class Artist

	# Public declarations
	public

    # Include log4r with parent log
    LOGGING_PARENT = :Model
    include Logging
	
		# Allow read-only access to fields
		attr_reader :name, :tags, :albums

    # Allow access to other fields
    attr_accessor :correct_name

		# Parametrised constructor, initializes fields
		def initialize(p_id3)	
		
			# Check parameter
			return unless p_id3.is_a? ID3LiteWrapper
		
			# Set artist name from ID3, revert to predefined value if unknown artist
			id3_name = p_id3.artist || Consts::VALUE_PLACEHOLDERS[:artist]

      # Sanitize name read from ID3, make it compatible to *some* common
      # folder/filename naming conventions across OSes.
      @name = FileSystemUtils::sanitize_filename(id3_name)
			
			# Initialize tags and albums arrays
			@tags = []
			@albums = []
		end
		
		# Adds a given tag to this artist's tags
		def add_tag(p_tag)

      # Sanitize the tag and add it to collection
      parsed_tag = ModelUtils::id3_sanitize(p_tag)
			@tags << parsed_tag
		end
			
		# Utility method, tries to add missing albums 
		# released by the *same* artist to the album Array.
		def add_missing_albums(p_same_artist)
		
			# Only try to add if it's really the same artist
			return if self != p_same_artist
			
			# Iterate through albums, see if the 'other' artist's albums are new
			p_same_artist.albums.each do |other_album|

				# Search for candidate album within own albums
				idx = @albums.index(other_album)
			
				# If the album wasn't found in own collection, add it
				if idx.nil?
          @albums << other_album
        else

          # TODO: Refactor to Album

					# Store matched album and its path
					current_album = @albums[idx]
					current_path_folder = current_album.path_folder
          other_album_path_folder = other_album.path_folder

					# If there is a match, check if the album is multi-disc, update path if so
					if FileSystemUtils::same_parent_folder(current_path_folder, other_album_path_folder)
						current_album.path = current_path_folder
            log.debug "[#{self.name}] Consolidated multi-disc album path #{other_album}"
          else

            if current_album.is_unknown? && other_album.is_unknown?

              log.debug "[#{self.name}] Matched multiple locations for unknown/non-album tracks "
              log.debug "[#{self.name}] Moving from '#{other_album_path_folder}' to '#{current_path_folder}'"
              ModelUtils::move_mp3s_to({
                :source => other_album_path_folder,
                :dest => current_path_folder
              })

            end
          end
					
				end # if
				
			end # each
		end
		
		# Adds a given album to this artist's releases
		def add_album(p_album)

			# Check parameter
			return unless p_album.is_a? Album

			# Only add album if not already present
			unless @albums.include?(p_album)
        log.debug "[#{self.name}] Added album #{p_album}"
				@albums << p_album
      else
        log.warn "Rejected album:"
        log.warn lpp p_album
      end
    end

    # Sanitized artist name
    def folder_friendly_name
      sanitized_id3 = ModelUtils::id3_sanitize(self.name)
      FileSystemUtils::sanitize_filename(sanitized_id3)
    end

		# Comparison operator
		def <=>(p_other_artist)
      # TODO: Fuzzy searching for misspelled album name
			self.name <=> p_other_artist.name
		end

		# Equality operator
		def ==(p_other_artist)
			self.name.eql?(p_other_artist.name)
		end
		
		# To String override
		def to_s

			# Artist name and tags (if loaded)
			buffer = "#{self.name}\n"
			buffer << @tags.join(",") unless @tags.empty?
			
			# Albums
			@albums.each do |album|
				buffer << "\t>> #{album}\n"
			end
			
			# Return buffer
			buffer
    end

end # class Artist