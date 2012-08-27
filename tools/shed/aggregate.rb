# Load dependencies
require "FileUtils"

# Project dependencies
require "tools/tool_base"

# Class description
class Aggregate < ToolBase

  # Public declarations
  public

    # Include log4r
    include Logging

    # Constructor, initializes fields
    def initialize(p_artist_cache, p_output_path)

      # Assign fields
      @artist_cache = p_artist_cache
      @output_path = p_output_path
    end

    # Launches the tool into action
    def launch
      begin

        # Iterate through each artist in the cache
        @artist_cache.artists.each do |artist|

          # TODO: Handle non-criticle errors (access denied usw.)

          # Construct artist drop path, create folder if necessary
          artist_drop_path = "#{@output_path}/#{artist.folder_friendly_name}"
          artist_drop_path_exists = File.exists?(artist_drop_path)

          # Get artist name and log start path
          artist_name = artist.name
          log.warn "[#{artist_name}] '#{artist_drop_path}'"

          # Iterate through each found album
          artist.albums.each do |artist_album|

            # Get album path, in both full and plain form
            album_path = artist_album.path_folder
            album_path_plain = artist_album.path_plain

            # Get album name, determine if non-album tracks
            album_unknown_placeholder = Consts::VALUE_PLACEHOLDERS[:album]
            album_is_unknown = artist_album.is_unknown?

            # Log the album which is being processed, report progress
            log.info "#{artist_album}"
            report_progress("Looking into #{artist.name}")

            # Edge case:
            #   If unknown albums reside in non-special 'unknown' folders,
            #   e.g. "Arctic Monkeys/Unknown--Tracks", adjust drop path to
            #   a 'unknown' folder, such as "Arctic Monkeys/Others""
            if album_is_unknown && !artist_album.is_located_in_special_unknown_folder?

              # Store new path, make folder if not present
              new_path = "#{File.dirname(album_path)}/#{album_unknown_placeholder}"
              unless File.exists?(new_path)
                FileUtils.mkdir(new_path)
                artist_drop_path_exists = true
              end

              log.debug("Moving from non-default named unknown folder '#{album_path_plain}' ")
              ModelUtils::move_mp3s_to({
                :source => album_path,
                :dest => new_path
              })

              # Replace non-special unknown folder name with special unknown folder
              album_path.sub!(album_path_plain, album_unknown_placeholder)
              album_path_plain = File.basename(album_path)

              # Log edge case
              log.debug("New unknown folder: #{album_path}")
            end

            # Edge case:
            #   The album was not in a specific folder e.g. 'MyBand/2005 - MyAlbum',
            #   but in a 'MyBand/.' folder, therefore don't explicitly create the folder.
            drop_path_is_album_path = File.basename(artist_drop_path).eql?(album_path_plain)

            log.debug "Artist drop path exists: #{artist_drop_path_exists} (#{artist_drop_path})"
            log.debug "Is album_path: #{drop_path_is_album_path}"

            folder_needs_to_be_created = !(artist_drop_path_exists || drop_path_is_album_path)
            log.info "Needs to be: #{folder_needs_to_be_created}"

            # Create drop folder, if required
            if folder_needs_to_be_created
              FileUtils.mkdir(artist_drop_path) unless File.exists?(artist_drop_path)
            end

            # Log results
            log.info "Moving"
            log.info "  '#{album_path}'"
            log.info "  '#{artist_drop_path}'"
            log.debug lsep

            # Set the album's final path (destination)
            artist_drop_path_with_album = "#{artist_drop_path}/#{album_path_plain}"

            # Finally, move the whole album into the artist drop path
            unless File.exists?(artist_drop_path_with_album)
              FileUtils.move(album_path, artist_drop_path)
            else
              ModelUtils::move_mp3s_to({
                :source => album_path,
                :dest => artist_drop_path_with_album
              })
            end

            # Update the album's final path (destination)
            artist_album.path = artist_drop_path_with_album
          end
        end

      # Log any exceptions
      rescue Exception => e
        log.error e
      end
    end

    # Reports progress, usually hooked
    # to a progressbar or notification area.
    def report_progress(p_args)
    end

    # Reports 'job done'
    def report_done
    end

  # Private declarations
  private

end # class Aggregate