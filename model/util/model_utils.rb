# Class description
module ModelUtils

  # Public declarations
  public

    # Include log4r with parent log
    extend Logging

    # Moves .mp3 Files from one Folder to another,
    # purging the source folder afterwards.
    #
    # Params:
    #   source -- The source folder, where the .mp3 files will be searched for
    #   dest   -- The destination folder, where the found files will be moved
    def self.move_mp3s_to(p_args)

      # Check arguments
      return unless p_args.has_keys?(:source, :dest)

      begin

        # Move the .mp3 files from the source to the destination,
        # deleting the source folder afterwards.
        require "util/file_system_utils"

        FileSystemUtils.move_contents_to_dir({
          :source => p_args[:source],
          :dest => p_args[:dest],
          :mask => Consts::MP3_MASK,
          :purge => true
        })

      # Rescue any Exception
      rescue Exception => e
        log.error e
      end
    end

    # Utility method, sanitizes a given ID3 String
    def self.id3_sanitize(p_str)

      # Only process actual strings
      return if p_str.nil?

      begin
        # Clear out whitespace and null chars
        p_str.strip!
        p_str.gsub!("\000", "")

        # Mark empty strings as nil
        p_str = nil if p_str.empty?

        # Return result
        p_str

      # Rescue any Exception
      rescue Exception => e
        log.error e
      end
    end

  # Private declarations
  private

end # class ModelUtils