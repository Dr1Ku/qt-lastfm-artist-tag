# Class description
module FileSystemUtils

  # Public declarations
  public

    # Include log4r with parent log
    LOGGING_PARENT = :FileSystemController
    extend Logging

    # Moves the *contents* of a given directory to another given directory.
    #
    # Params:
    #   source -- The source folder, where the contents will be searched for
    #   dest   -- The destination folder, where the found contents will be moved/copied
    #   mask   -- The mask to use in the search process, see RDoc of 'Dir.glob'
    #             for further mask examples, '*.*' used if param is nil
    #
    #   recursive -- Will the search process be recursive? Default false. [Optional]
    #   no_move   -- Only copy the files, don't move them. Default false. [Optional]
    #   purge     -- The source folder will be deleted after the operation. Default false. [Optional]
    def self.move_contents_to_dir(p_args)

      # Check arguments
      return unless p_args.is_a?(Hash) && p_args.has_keys?(:source, :dest, :mask)

      # Edge cases
      return if p_args[:source].eql?(p_args[:dest])

      # Initialize result
      result = true

      # Recalibrate arguments
      p_args[:mask] ||= "*.*"
      p_args[:recursive] = p_args[:recursive] || false
      p_args[:no_move] ||= p_args[:no_move] || false
      p_args[:purge] ||= p_args[:purge] || false

      # Scan through the source, looking for files matching the mask
      files = FolderScanner.scan({
        :path => p_args[:source],
        :mask => p_args[:mask],
        :recursive => p_args[:recursive],
        :depth => -1
      })

      # Apply method (copy or move to destination)
      method = p_args[:no_move] ? "copy" : "move"
      while !files.empty? do
        current_entry = files.pop

        source = current_entry[:file]
        destination = p_args[:dest]

        FileUtils.send(method, source, destination) unless source.eql?(destination)
      end

      # Purge the source directory, if needed
      if p_args[:purge]
        begin
          FileUtils.rmdir(p_args[:source])
        rescue
          # Let it slide
        end
      end

      # Return result
      result
    end

    # Utility method, sanitizes a given string representing a filename
    # by using some regular rules for file and folder names across OSes.
    def self.sanitize_filename(p_str)
      p_str.gsub(/[\/:*?"<>|^;]/, "")
    end

    # Utility method, checks if two folders share the same
    # parent folder at some point in the ancestor tree.
    def self.same_parent_folder(p_folder_a, p_folder_b)

      # Check params
      return false unless folder_exists?(p_folder_a)
      return false unless folder_exists?(p_folder_b)

      # Edge cases
      are_identical = File.identical?(p_folder_a, p_folder_b)
      return true if are_identical

      # Move up into the path tree until identical.
      # *Warning* :
      #   Root elements count as well, use is_root_path? to eventually distinguish
      #   if the paths are identical at a root level or not.
      until are_identical
        p_folder_a = File.dirname(p_folder_a)
        p_folder_b = File.dirname(p_folder_b)

        are_identical = File.identical?(p_folder_a, p_folder_b)
      end

      # Return result
      are_identical
    end

    # Utility method, checks if a given path string points to the root element
    # (UNIX: "/", Win: "<DriveLetter>:/"). Not sure about other OS flavours though!
    def self.is_root_path?(p_path)
      root_char = "/"
      last = p_path.length - 1
      p_path.slice(last..last).eql?(root_char)
    end

  # Private declarations
  private

    # Checks if a given variable is indeed a Dir (folder) which exists
    def self.folder_exists?(p_candidate)
      !p_candidate.nil? && File.directory?(p_candidate)
    end

end # class FileDirUtils