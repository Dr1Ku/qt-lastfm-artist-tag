# Project dependencies
require "controller/network_connection_controller"
require "controller/filesystem_controller"

require "lib/last_fm_api_request"

require "gui/widgets/extended/multi_timed_object"

require "tools/shed/aggregate"

# Class description
class LastFmAPIController < MultiTimedObject

  # Public declarations
  public

    # Include log4r
    include Logging

		# Parametrised constructor, initializes fields
		def initialize(p_view)
      super(p_view)

      # Initialize attributes
      @artist_cache = nil

      # Assign attributes
      @view = p_view

      # Initialize network controller
      @network = NetworkConnectionController.new(@view)
    end

    def go

      # TODO: Artist similarity filter, W.A.S.P. vs W.A.S.P

#      path = "M:/!!!##Y'ALL SORT THIS HERE MUZ/##DONE"
      path = "M:/~!CheckMuz/_k/#Done"

      file_system = FileSystemController.new(@view,
        lambda { |cache, problematic, alternatives|
          get_tags({:cache => cache,
                    :problematic => problematic,
                    :alternatives => alternatives})
        }
      )
      file_system.start_scanning(path)
    end

    def get_tags(p_args)
      @artist_cache = p_args[:cache]

      # TODO: Issue notification, no mp3s found
      puts "empty" if @artist_cache.empty?

      #create_timer({ :sym => :net })

      p = "M:/~!CheckMuz/_k/##Sorted"
      Aggregate.new(@artist_cache, p).launch
    end

		# Retrieves the top 'x' tags for a given Artist,
		# see settings above for tweaking.
		def get_tags_for(p_artist)

      # Create notification -- request sent
      @view.issue_notification({
        :type => :info,
        :text => @view.tr("Tagging #{p_artist.name} via last.fm . . .")
      })

      LastFmAPIRequest.new(p_artist, @network).dispatch(:toptags)
    end

  # Private declarations
  private

    # Timer Event 'demultiplexer', handles a given timer (poorman's thread)
    def process_timer(p_sym)

      # Handle timer depending on symbol ('id')
      case p_sym

        # One-shot timer to scan the given folder
        when :net

          # Get tags for each artist in the cache
          @artist_cache.artists.each do |artist|
            get_tags_for(artist)
          end

      end
    end

end # class LastFmAPIController