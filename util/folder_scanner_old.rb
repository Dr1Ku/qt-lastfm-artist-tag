# Discarded since quite slow vs Dir.glob with file mask.
# Since recursive, the *last* file of each album was
# returned, which is not optimal for tags (last tracks
# have hidden tracks (e.g. 2x, 3x normal filesize).
#
#      user     system      total        real
#  0.437000   0.874000   1.311000 (  1.344077)
#  0.109000   0.109000   0.218000 (  0.207012)
#
# => Glob with *.mp3 mask and first found filter is 7x faster
# Dataset: 40GB file collection (7K files, 760 folders)


# Load dependencies
require "find"

class FolderScannerOld

	# Public declarations
	public

    # Include log4r with parent log
    LOGGING_PARENT = :LastFmAPIController
    include Logging
	
		# Parametrised constructor, initializes fields
    #
    # Parameters: path -- The path to search through (e.g. D:\music)
    #
    #             extension -- The extension to look for (e.g. ".mp3"), default *.* [Optional]
    #             depth -- How many files to add, per folder (e.g. only scan first track
    #                      of a given, presumingly properly ID3-tagged mp3 folder),
    #                      by default scans through all the files of a folder [Optional]
		def initialize(p_args)

			# Scan path (where to start the file search from)
			@scan_path = p_args[:path]

			# Scan extension (only look at files with the given extension),
			# e.g. ".mp3", ".jpg" and so on
			@scan_extension = p_args[:extension]

      # How many files are scanned per folder (default is 1 -- fastest)
      @scan_depth = p_args[:depth] || 1

      # A cache containing folders which have been scanned
      @scan_history = {}
		end
		
		# List method, returns a list of absolute paths
		# of (recursively) found files in the given folder,
		# optionally filtered by a given extension
		def list
			begin

				# Prepare result, array of absolute paths for found files
        # within given directory. Also empty cache
				result = []
        @scan_history = {}

				# Recursively scan current folder for files
				Find.find(@scan_path) do |current_full_path|

					# Get filename, prune if dot
					filename = File.basename(current_full_path)
          Find.prune if filename[0] == ?.

          # Get extension
          extension = File.extname(current_full_path)

					# Check for file extension, if provided
					if @scan_extension && extension.eql?(@scan_extension)

            # Get foldername
            folder_name = File.dirname(current_full_path)

            # Get number of files parsed in current folder, default 0
            folder_depth = @scan_history.fetch(folder_name, nil) || 0
            Logging[self].debug "At #{folder_name}" if folder_depth == 0

            # If the desired depth hasn't been reached
            unless folder_depth == @scan_depth

              # Increase current depth
              folder_depth += 1

              # Add and log result
              Logging[self].warn "Result: '#{current_full_path}'"
              result << current_full_path

              # Update cache, proceed no further in this folder
              @scan_history[folder_name] = folder_depth
              Find.prune
            end
					else
					
						# Either move beyond this file, if we're searching
						# for specific files (filtered by extension), or add
            # the path to the result (since no filter applied)
						@scan_extension ? next : (result << current_full_path)
					end
										
        end # find block

        # Log final result length
        Logging[self].info "Retrieved #{result.length} results"

				# Return result
				result

			# Rescue any exceptions
			rescue Exception => e
				Logging[self].error e
        nil
			end
		end	

end