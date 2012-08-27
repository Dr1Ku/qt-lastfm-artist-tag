# Project dependencies
require "model/artist"
require "model/album"
require "model/artist_cache"

require "util/folder_scanner"
require "lib/id3_lite_wrapper"

require "gui/widgets/extended/multi_timed_object"

# Class description
class FileSystemController < MultiTimedObject

  # Public declarations
  public

    # Include log4r
    include Logging

		# Parametrised constructor, initializes fields
		def initialize(p_view, p_done_callback)
      super(p_view)

      # Initialize settings
      @@settings = {
        :retry_depth => 3
      }.freeze

      # Initialize attributes
      @current_path = nil

			# Initialize Artist and File Cache
			@artist_cache = ArtistCache.new
      @audio_file_queue = []

      # Initialize caches for problematic audio files
      # (unreadable/missing ID3 Tag(s) )
      @audio_files_problematic = {}
      @audio_file_alternatives = []

      # Assign attributes
      @view = p_view
      @done_callback = p_done_callback
    end

    # Public method, starts scanning the given
    # path for audio files.
    def start_scanning(p_path)

      # Store path, start reader
      @current_path = p_path
      create_timer({ :sym => :scanner })
    end

  # Private declarations
  private

    # Timer Event 'demultiplexer', handles a given timer (poorman's thread)
    def process_timer(p_sym)

      # Handle timer depending on symbol ('id')
      case p_sym

        # One-shot timer to scan the given folder,
        # forward event to handler
        when :scanner
          scan

        # Multi-shot timer to read ID3 tags from the
        # given folder, forward event to handler
        when :reader
          read
      end
    end

    # One of the main processing methods, scans the current path
    # for audio files, starting the ID3 Tag Reader when done.
    def scan

      # Start scanner
      start_scan(@current_path)

      # Update status
      @view.issue_notification({
        :type => :ok,
        :text => @view.tr("Scanning done. Reading ID3 Tags from #{@audio_file_queue.length} mp3 Files . . .")
      })

      # Start reader
      create_timer({ :sym => :reader, :one_shot => false })
    end

    # Scans a given folder for audio files (*.mp3), returning
    # a Queue with files processed (in ascending order)
    def start_scan(p_path)

      # Create notification -- scanner started
      @view.issue_notification({
        :type => :info,
        :text => @view.tr("Scanning paths for MP3 Files . . .")
      })
      log.debug("[Scanner] Started.")

      # TODO: Handle situation in which no MP3s exist in folder
      # TODO: - When same folder, diff album!
      # TODO: - More artists/folder => In collection for given artist
      # Scan folder for Audio Files (.mp3 Files)
      @audio_file_queue = FolderScanner.scan({
        :path => p_path,
        :mask => Consts::MP3_MASK
      })
    end

    # One of the main processing methods, reads ID3 Tags from a given queue
    # of audio files to be processed (created by the scanner)
    def read
      begin

        # Check if there are any more files left to process
        if @audio_file_queue.empty?
          read_finished
          return
        end

        # Consume an audio file from the queue
        current_audio_file_container = @audio_file_queue.pop
        log.debug lsep
        log.debug "[Reader] Queue consume, #{@audio_file_queue.size} remaining"

        # Inform user about progress, retrieve current audio_file
        current_audio_file = update_status(current_audio_file_container)

        # Process tag, retrieving artist. Result is nil if tag is empty
        parsed_artist = read_tag(current_audio_file)

        # Check if the parsed artist is nil (only when empty/unreadable ID3 Tags)
        if parsed_artist.nil?

          # Forward the event to handler
          read_unsuccessful(current_audio_file_container)
        else

          # Add parsed artist to cache; won't be added if already cached
          @artist_cache << parsed_artist

          # Query if the successfully read audio file was previously marked
          # as an alternative to a unreadable file. If so, store this file
          # as a sole successful alternative (e.g. discard other alternatives)
          if previously_flagged_as_alternative?(current_audio_file_container)
            alternative_found(current_audio_file_container)
          end

        end

      # Rescue any exception
      rescue Exception => e
        log.error e
      end

    end # read

    # Event Handler, fired when a new audio file is up for processing
    # Retrieves path-related details and refreshes the Notification Bar.
    def update_status(p_audio_file_container)

      # Retrieve path-related attributes for the current audio file
      folder        = p_audio_file_container[:folder]
      filename      = p_audio_file_container[:filename]
      relative_path = "#{folder}\\#{filename}" # TODO: Eventually path mechanics, combine
      current_audio_file = p_audio_file_container[:file]

      # Refresh UI with current status
      @view.update_notification({
        :type => :info,
        :text => tr("Processing \"#{relative_path}\" . . .")
      })

      # Return to be processed audio-file
      current_audio_file
    end

    # Utility method, resets the cache of alternatives for a given audio file,
    # since the alternative worked (was successfully read).
    def alternative_found(p_audio_file)

      # Iterates through each problematic file, searching for the alternative
      # which worked. Replaces the array of alternatives with itself, if found.
      @audio_files_problematic.each_pair do |key, value|

        # If found within the array of possible alternatives
        if value.include?(p_audio_file)

          # Log event
          log.debug "[Reader] Marked '#{p_audio_file[:file]}' as succesful alternative for '#{key[:file]}'"

          # Discard other alternatives (former value for current key)
          @audio_files_problematic.delete(key)

          # Store at same key, with updated hash
          @audio_files_problematic.store(
            key.merge({ :successful => true }),
            [p_audio_file]
          )
        end
      end

    end

    # Utility method, queries the global problematic audio file
    # cache for the given audio file. If found, deletes and returns
    def previously_flagged_as_alternative?(p_audio_file_container)

      # Don't bother if there are no alternatives stored
      return false if @audio_file_alternatives.empty?

      # Search for the audio file within the cache, delete if found
      idx = @audio_file_alternatives.index(p_audio_file_container)
      found = (!idx.nil?)

      # If found, issue log message and delete from array
      @audio_file_alternatives.delete_at(idx) if found

      # Return result
      found
    end

    # Event Handler, fired when a given audio file
    # is flagged as contains an empty/unreadable ID3 Tag
    def read_unsuccessful(p_audio_file_container)
      begin

        # Cache current fire, used frequently
        current_file = p_audio_file_container[:file]

        # Check if the allegedly unsuccessful audio file is a usual suspect,
        # e.g. was already flagged as an alternative audio file and return
        # if true.The scanner would have returned the same alternatives,
        # leading to an infinite loop.
        if previously_flagged_as_alternative?(p_audio_file_container)
          log.warn "[Reader] Alternative '#{current_file}' also empty/unreadable."
          return
        end

        # Log event
        log.warn "[Reader] Empty/unreadable ID3 Tags, '#{current_file}'"

        # Scan for two other audio files in the
        upper_folder = File.dirname(current_file)
        other_files = FolderScanner.scan({
          :path => upper_folder,
          :mask => Consts::MP3_MASK,
          :recursive => false,
          :depth => @@settings[:retry_depth]
        })

        # Try to retrieve details from other audio files within the same folder
        while !other_files.empty?

          # Retrieve new file from the queue, pass if the same file
          current_alternative = other_files.pop
          next if current_alternative[:file].eql?(current_file)

          # Enqueue alternate file for later processing
          enqueue_for_retry(p_audio_file_container, current_alternative)
          log.info "[Reader] Enqueued alternative : '#{current_alternative[:file]}'"
        end

        # Log edge case, no alternatives present
        log.warn "[Reader] No further alternatives found." if other_files.empty?

      # Log any errors
      rescue Exception => e
        log.error e
      end
    end

    # Event Handler, fired when an alternative for a previously unsuccessful
    # audio file has been found. The alternate audio file is enqueued for later processing,
    # along with the original audio file which had the unreadable/empty ID3 Tag
    def enqueue_for_retry(p_origin_file_container, p_alternate_audio_file_container)

      # Cache alternative and origin
      @audio_files_problematic[p_origin_file_container] = [] if @audio_files_problematic[p_origin_file_container].nil?
      @audio_files_problematic[p_origin_file_container] << p_alternate_audio_file_container

      # Cache in global cache for alternative audio files as well,
      # will be removed if the alternative is flagged again as unreadable
      @audio_file_alternatives << p_alternate_audio_file_container

      # Enqueue into main processing queue
      @audio_file_queue.push(p_alternate_audio_file_container)
    end

    # Reads ID3 Tags from a given audio file,
    # returning the artist if successful.
    def read_tag(p_audio_file)
      begin

        # Log progress
        log.debug "[Reader] '#{p_audio_file}' :"

        # Read ID3 Tags from the given file, abort if empty
        id3_tag = ID3LiteWrapper.new(p_audio_file)
        return nil if id3_tag.empty?

        # Sanitize the newly read ID3 Tag, log output
        #id3_tag.sanitize!
        log.debug lpp [id3_tag.artist, id3_tag.album, id3_tag.year]

        # Derive artist and album from ID3 Tags
        artist = Artist.new(id3_tag)
        album = Album.new(id3_tag, p_audio_file)

        log.debug "Resulting artist: #{artist}"
        log.debug "Resulting album: #{album}"

        # Add the album to the given artist
        artist.add_album(album)

        # Return processed artist as result
        artist

      # Rescue any exception
      rescue Exception => e
        log.error e
      end
    end

    # Event Handler, fired when all audio files
    # have been processed.
    def read_finished

      # Stop current timer
      stop_current_timer

      # Update GUI state
      @view.update_notification({
        :type => :ok,
        :text => tr("Read ID3 Tags")
      })

      # Log results
      log.debug "[Reader] Processing finished, results :"
      log.debug @artist_cache.to_s

      log.debug "[Reader] Problematic files :"
      log.debug lpp @audio_files_problematic

      log.debug "[Reader] Alternative files :"
      log.debug lpp @audio_file_alternatives

      # Post done callback
      @done_callback.call(@artist_cache,
        @audio_files_problematic,
        @audio_file_alternatives
      )
    end

end # class FileSystemController