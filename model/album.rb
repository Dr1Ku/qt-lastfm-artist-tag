class Album
	
	# Public declarations
	public

    # Include log4r with parent log
    LOGGING_PARENT = :Model
    include Logging
		
		# Allow read-only access to fields
		attr_reader :name, :year
		
		# Allow read-write access to fields
		attr_accessor :path, :alternate_paths
		
		# Parametrised constructor, initializes fields
		def initialize(p_id3, p_absolute_path)
		
			# Check parameter
			return unless p_id3.is_a? ID3LiteWrapper
		
			# Store album's name and release year
			@name = p_id3.album
			@year = p_id3.year
			
			# Revert to predefined values if non-album tracks
			@name = Consts::VALUE_PLACEHOLDERS[:album]   if @name.nil?
			@year = Consts::VALUE_PLACEHOLDERS[:generic] if @year.nil?
			
			# Store album absolute path on storage media
			@path = p_absolute_path
    end

    # Check if album name is known
    def is_unknown?
      self.name.eql?(Consts::VALUE_PLACEHOLDERS[:album])
    end

    # Returns true if the unknown is album already
    # placed within the 'unknown'-type folder (e.g. 'Others')
    def is_located_in_special_unknown_folder?
      self.path_plain.eql?(Consts::VALUE_PLACEHOLDERS[:album])
    end

    # Returns only the last component of the path, usually
    # self.year - self.name (e.g. '2006 - My album')
    def path_plain
      File.basename(self.path_folder)
    end

    # Returns the folder in which the mp3 file used to
    # identify the album resides, usually
    # self.year - self.name (e.g. '2006 - My album')
    def path_folder
      File.dirname(self.path)
    end

		# Comparison operator
		def <=>(p_another_album)
      # TODO: Fuzzy searching for misspelled album name
			self.year <=> p_another_album.year && self.name <=> p_another_album.name
		end
		
		# Equality operator
		def ==(p_another_album)
			self.year.eql?(p_another_album.year) && self.name.eql?(p_another_album.name)
		end		
		
		# To String Override
		def to_s
			"(#{self.year}) - #{self.name} ['#{self.path}']"
    end

end # class Album