# A quick folder scanner, yields a number of files within
# the given directory (and its subfolders) which match
# the given filemask.
#
# Fast since it scans *a single file* (per default) per folder.
class FolderScanner

  # Public declarations
  public

    # Main entry point, scans the given path
    # for files matching the filemask (e.g. '*.mp3')
    #
    # Params: path -- The (absolute) path to scan
    #         mask -- The mask to use, see RDoc of
    #                 'Dir.glob' for further mask examples
    #
    #         recursive -- Is the scanning recursive? Default true. [Optional]
    #         depth -- The number of files to return per unique folder. Default 1 [Optional]
    def self.scan(p_args)

      # Check parameters
      return unless p_args.has_keys?(:path, :mask)

      # Recalibrate parameters
      p_args[:recursive] = true if p_args[:recursive].nil?
      p_args[:recursive] ? mask = "**/#{p_args[:mask]}" : mask = p_args[:mask]

      # Recalibrate depth, a depth of <= 0 means 'all files'
      p_args[:depth] ||= 1
      depth = p_args[:depth]
      shallow = (depth == 1)
      depths = {} unless shallow

      # Glob glob glob on those files and directories
      files = Dir.glob("#{p_args[:path]}/#{mask}")

      # Prepare cache and result
      visited = {}
      result = Queue.new

      # Traverse found files
      files.each do |file|

        # Get folder name, skip if visited
        folder = File.dirname(file)
        next if visited[folder]

        # Mark path as visited (if depth is 1), else increment counter
        visited[folder] = shallow
        unless shallow
          depths[folder].nil? ? depths[folder] = 1 : depths[folder] = depths[folder] + 1
          visited[folder] = (depth > 0) && (depths[folder] >= depth)
        end

        # Add to results
        result << {
          :file => file,
          :folder => File.basename(folder),
          :filename => File.basename(file)
        }

      end

      # Return result
      result
    end

end # class FastFolderScanner