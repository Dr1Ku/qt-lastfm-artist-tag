class ArtistCache

	# Public declarations
	public

    # Include log4r with parent log
    LOGGING_PARENT = :Model
    include Logging

    # Readable attributes
    attr_reader :artists
	
		# Default constructor, initializes fields
		def initialize
		
			# Initialize processed artists array
			@artists = []
		end
			
		# Tests if a given artist's tags have
		# already been retrieved (are cached).
		def include?(p_artist)

			# Check parameter
			return unless p_artist.is_a? Artist
			
			# Return result
			@artists.include?(p_artist)
    end

    # Utility method, test if the cache is empty
    def empty?
      @artists.empty?
    end

    # Utility method, retrieves a given artist by name
    def cached_artist(p_name)
      @artists.select { |current_artist| current_artist.name.eql?(p_name) }
    end

		# Adds a given artist to the artist cache
		def <<(p_artist)

			# Check parameter
			return unless p_artist.is_a? Artist
			
			# Search for the given artist within the cache
			idx = @artists.index(p_artist)
			
			# If the artist was not cached
			if idx.nil?

				# Add the artist to the cache
				@artists << p_artist
        log.debug "[#{p_artist.name}] ArtistCache add"
      else

				# Retrieve the artist from the cache
				cached_artist = @artists[idx]
        log.debug "[#{cached_artist.name}] ArtistCache hit"

        # Try to add missing artist's albums
				cached_artist.add_missing_albums(p_artist)
			end
		end
		
		# To String override
		def to_s

			# Prepare buffer
			buffer = "\n"
			
			# List all artists in cache, inverse order
			@artists.each do |artist|
				buffer += "#{artist}\n"
			end
			
			# Return buffer
			buffer
		end

end # class ArtistCache