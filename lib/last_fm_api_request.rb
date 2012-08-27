# Load dependencies
require "fastthread"
require "uri"
require "rexml/document"

# Project dependencies
require "controller/last_fm_api_controller"

# Class description
class LastFmAPIRequest < Qt::Object

  # Public declarations
  public

    # Include log4r with parent log
    LOGGING_PARENT = :LastFmAPIController
    include Logging

    # Accessible attributes
    attr_accessor :last_fm_api_settings

    # Slot declarations
    slots "data_ready()"

    # Constructor
    def initialize(p_artist, p_network_manager)
      super(nil)

      # Initialize thread and mutex
      @thread = nil
      @mutex = Mutex.new

      # Initialize XML Reader
      @xml_reader = Qt::XmlSimpleReader.new

      # Assign attributes
      @artist = p_artist

      # Initialize network-related attributes
      @network_manager = p_network_manager
      @reply = nil

      # Initialize API settings
      @last_fm_api_specifics = {

        :url =>
        {

           # Initialize URL for last.fm's 'toptags' API Method
          :toptags => build_url(
                      {
                        :method => "artist.gettoptags",
                        :params => { :autocorrect => 1, :artist => "" }
                      }),

           # Initialize URL for last.fm's 'getimages' API Method
          :images  => build_url(
                      {
                        :method => "artist.getimages",
                        :params => { :order => "popularity", :limit => 1, :autocorrect => 1, :artist => "" }
                      })
        },

              # TODO: Refactor to request pars0r
        :xpath =>
        {

          # Initialize XPaths for last.fm's 'toptags' API Method
          :toptags => {
            :artist_name   => "//toptags/artist",
            :tag_name      => "//toptags/tag/name",
            :tag_count     => "//toptags/tag/count",
          },

          # Initialize XPaths for last.fm's 'getimages' API Method
          :images  => {
            :artist_name   => "//images/artist",
            :pic           => "//sizes/name//large",
          },

          # Generic error for a request
          :request_error => "/lfm/error",
        }
      }.freeze

      # Initialize internal settings for last.fm's 'toptags' API Method
      @last_fm_api_settings = {
        :min_tagged_count    => 45,
        :max_tags_per_artist => 3
      }.freeze

      # Create new log for Web-related logging
      log_create({ :class => self.class, :suffix => "web" })
    end

    # Main entry point, creates a new Thread with a critical section for tag retrieval
    # via the last.fm API. The critical section is motivated by the fact that more
    # threads can access the given @artist at any given time, looking to tag the
    # artist and adding tags as they are found. The method uses the network manager
    # to issue HTTP Requests to the last.fm API. Handling is within data_ready.
    def dispatch(p_key)
      begin

        # Enter critical section
        @mutex.synchronize do

          request_url = @last_fm_api_specifics[:url][p_key] + URI.escape(@artist.name)

          # Create a HTTP Request and send it to the last.fm API
          @reply = @network_manager.dispatch_request({
            :url => request_url,
            :operation => :get,
            :error_tolerant => false,
            :error_handler => lambda { |error| err(error) }
          })

          # Connect the 'have just received a chunk of data' signal to its slot
          Qt::Object::connect(@reply, SIGNAL("readyRead()"), self, SLOT("data_ready()"))

          # Log that the request has been sent
          log(:web).info "[#{@artist.name}] Sent request to last.fm API"

          # Done with this part of the job, unlock the mutex
          @mutex.unlock

        end

      # Rescue any exceptions
      rescue Exception => e
        log(:web).error e
      end
    end

    # Error Handler for HTTP Requests to the last.fm API
    def err(p_err)
      log(:web).warn p_err unless p_err.value == Qt::NetworkReply::NoError
    end

  # Private declarations
  private

    # Utility method, builds a URL for the last.fm API with the given parameters.
    #
    # Params: method -- The name of the last.fm API method to use
    #         params -- A Hash containing the parameters to pass. A good practice
    #                   here is to leave the last param empty and append with data
    #                   afterwards, e.g. :params => { [...], :artist => "" }
    def build_url(p_args)

      # Initialize API Details
      last_fm_api_key = "2307db455e946abf91bf3a4784e9f1d7".freeze

      # Build HTML params, differentiate between empty ones
      request_params = ""
      empty_params = ""
      p_args[:params].each do |key, value|
        param_s = "&#{key}=#{value}"
        value.is_a?(String) && value.empty? ? empty_params += param_s : request_params += param_s
      end

      # Create URL
      url =
        "http://ws.audioscrobbler.com/2.0/?api_key=#{last_fm_api_key}&method=#{p_args[:method]}" +
        request_params + empty_params

      # Return result
      url
    end

    # Event Handler, fired when the NetworkRequest has received a NetworkReply
    # containing data. Specifically, fired when the last.fm API has produced
    # an XML Result for the given artist's 'toptags'. Forwards to XML parse.
    def data_ready
      begin

        # Parse received XML data
        @mutex.synchronize do

          # If there is still data left to read
          unless @reply.atEnd

            # Cache artist's name
            artist = @artist.name

            # Read data
            data = @reply.readAll
            log(:web).debug "[#{artist}] Received #{data.length} bytes from last.fm API"
            log(:web).debug "[#{artist}] Parsing last.fm API's XML result"

            # Parse data
            parse_xml(data)
            log(:web).debug "[#{artist}] Parsed last.fm API's XML result"
          end
        end

      # Rescue any exceptions
      rescue Exception => e
        log(:web).error e
      end
    end

		# Parses the received XML, reading tag names and their respective counts,
		# adding tags to the artist as necessary.
		def parse_xml(p_data)
			begin

        # Cache artist's name
        artist = @artist.name

        # Construct XML Document from the QByteArray
        xml = REXML::Document.new(p_data.data)

        log.warn(p_data.data)

        # TODO: Refactor to request pars0r

        # Prepare settings
        min_tagged_count = @last_fm_api_settings[:min_tagged_count]
        max_tags_count   = @last_fm_api_settings[:max_tags_per_artist]

				# Parse XML, looking for a 'tag-name' and a 'tagged-count' match
				tag_names  = REXML::XPath.match(xml, @last_fm_api_specifics[:xpath][:toptags][:tag_name])
				tag_counts = REXML::XPath.match(xml, @last_fm_api_specifics[:xpath][:toptags][:tag_count])

				# Iterate through delivered tags
				tag_counts.each_with_index do |tag_count, i|

					# Retrieve the number of times the artist was
					# tagged with the current tag, parse to Integer
					tag_count = Integer(tag_count.text)

					# Pass over outliers, 0 and 1 are interpreted as Fixnums
					next if [0,1].include?(tag_count)

          # Retrieve tag
          tag_name = tag_names[i].text.strip.capitalize

					# Only accept tags which have been applied at least 'x'
          # times by the community (see @last_fm_api_settings above)
					if tag_count >= min_tagged_count

            # Log event
            log(:web).info "[#{artist}] Tagged '#{tag_name}' (#{tag_count} >= #{min_tagged_count}) "

						# Add the given tag to the artist
						@artist.add_tag(tag_name)

						# Leave loop if already found enough tags
						break if @artist.tags.count >= max_tags_count
          else

            # Make a note of lesser-used tags
            log(:web).debug "[#{artist}] Not tagged '#{tag_name}' (#{tag_count} < #{min_tagged_count})"
          end

        end # each

        # Check if the API call didn't return any results (possible error)
        if tag_names.empty?
          error = REXML::XPath.match(xml, @last_fm_api_specifics[:xpath][:request_error])
          unless error.empty?
            error = error[0]
            log(:web).error "The last.fm API returned an error : #{error.text.strip}"
          end
        end

			# Rescue any exceptions
      rescue Exception => e
        log(:web).error e
      end

		end

end # class LastFmAPIRequest