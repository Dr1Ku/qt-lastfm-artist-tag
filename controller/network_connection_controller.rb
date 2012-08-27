# Project dependencies

# A Controller for network (Internet) connectivity,
# e.g. handling connections to the last.fm API.
class NetworkConnectionController < Qt::Object

	# Public declarations
	public
	
		# Slot declarations
		slots "request_finished(QNetworkReply*)"

		# Parametrized constructor, initializes fields
		# with the values provided
		def initialize(p_view)
			super
			
			# Initialize constants
			@@settings = {
				:error_threshold => 2,
				:http_requests => { 
					:head => Qt::NetworkAccessManager::HeadOperation,
					:get  => Qt::NetworkAccessManager::GetOperation,
					:put  => Qt::NetworkAccessManager::PutOperation,
					:post => Qt::NetworkAccessManager::PostOperation
				}	
			}
			
			# Assign attributes
			@view = p_view
			
			# Initialize attributes
			@request_callback = nil
			@request_cache = {}
			
			# Create network manager
			@manager = Qt::NetworkAccessManager.new
			Qt::Object::connect(@manager, SIGNAL("finished(QNetworkReply*)"), self, SLOT("request_finished(QNetworkReply*)"))
		end
		
		# Checks for an Internet connection, posting the result  
		# using the provided callback.
		def check_connection(p_callback = nil)
			@request_callback = p_callback
			send_test_request
    end

		# HTTP Request dispatcher, uses the NetworkManager to dispatch a request.
		# Params: url -- The URL to send the request to
		#         operation -- One of [:head, :get, :put, :post] (see @@SETTINGS[:http_requests])
    #
		#         callback -- Reply callback [Optional]
		#         repeat -- Set to true if the request is to be resent if unsuccessful [Optional]
		#         error_handler -- A Lambda/Proc for an error handler (i.e. display a notification) [Optional]
		#					error_tolerant -- Bool, default true. If false, the error handler is called when the first
    #                           error occurs and not when the (@@SETTINGS[:error_threshold] + 1)th error occurs.
		def dispatch_request(p_args)

			# Check for required parameter, :operation
			unless @@settings[:http_requests].has_key?(p_args[:operation])
				puts "NetworkConnectivityController::dispatch_request -- Only use one of [#{@@settings[:http_requests].keys.join(',')}] as :operation !"
				return
			end

			# Check for required parameter, :url
			unless p_args.has_key?(:url)
				puts "NetworkConnectivityController::dispatch_request -- :url (URL) required !"
				return
			end

			# Create request and set its callback
			request = request_for_url(p_args[:url])
      @request_callback = p_args[:callback] unless p_args[:callback].nil?

      # Recalibrate received parameters
			operation = p_args[:operation].to_s
      p_args[:error_tolerant] = true if p_args[:error_tolerant].nil?

      # Add request to cache
			@request_cache[request] = {
        :operation => operation,
        :error_count => 0,
        :error_tolerant => p_args[:error_tolerant],
        :error_handler => p_args[:error_handler],
        :repeat => p_args[:repeat]
      }

			# Dispatch request
			reply = @manager.send(operation, request)

      # Return newly created (empty) Qt::NetworkReply
      reply
    end
			
	# Private declarations
	private
	
		# Event Handler, fired when a network request is to be sent.
		# Ensures that the dispatch_request method was used to create it.
		def createRequest(p_operation, p_request, p_io_device)
			
			# Hold the request for ransom :)
			unless request_cache_find(p_request)
				puts "NetworkConnectivityController::createRequest: No dispatch_request call used to issue this request, discarding !"
				return
			end
			
			# Release the request into the wild
			super(p_operation, p_request, p_io_device)
		end
		
		# Utility method, searches for a given request within the cache
		def request_cache_find(p_request)
		
			# Prepare result
			result = nil
		
			# Search for the request within the cache's keys, set result if found
			find_result = @request_cache.keys.select { |cached_request| cached_request == p_request }
			result = find_result[0] unless find_result.empty?
				
			# Return result
			result
		end
		
		# Event Handler, fired when a network request has finished
		def request_finished(p_reply)

      # Send reply to handler (default or custom)
			@request_callback.nil? ? handle_reply(p_reply) : @request_callback.call(p_reply)

      # Reset the callback
      @request_callback = nil
    end

    # Wrapper for a call to the request's error handler.
    # Also deletes the request from the cache
    def call_error_handler(p_request, p_error_handler, p_error)

      # Call handler if available
      p_error_handler.call(p_error) unless p_error_handler.nil?

      # Remove request from cache
      @request_cache.delete(p_request)
    end
		
		# Network reply handler, fired when a network reply has been posted
		def handle_reply(p_reply)
		
			# Retrieve Error value
			error = p_reply.error.value
			
			# Only handle error messages if an error occured
			return if error == Qt::NetworkReply::NoError
			
      # Retrieve the initial, equivalent request from the cache
      initial_request = request_cache_find(p_reply.request)
      unless initial_request.nil?

        # Retrieve request details
        request_details = @request_cache[initial_request]
        unless request_details.nil?

          # Check if the error handler is to be called at once (is error-tolerant or not)
          unless request_details[:error_tolerant]
            call_error_handler(initial_request, request_details[:error_handler], p_reply.error)
            return
          end

          # Increase the error count for the request
          request_details[:error_count] += 1

          # Check if the reported error has occured before and,
          # if it has past the error threshold, post callback
          if request_details[:error_count] > @@settings[:error_threshold]
            call_error_handler(initial_request, request_details[:error_handler], p_reply.error)
            return
          end

          # If the request is repeatable, resend it
          @manager.send(request_details[:operation], initial_request) if request_details[:repeat]

        end # unless request_details
      end # unless initial_request

		end # handle_reply
		
		# Error handler for send_test_request, issues a notification
		def no_connection(p_error)
      pp p_error
      # TODO: More specific error message, http://doc.qt.nokia.com/4.6/qnetworkreply.html#NetworkError-enum
		  @view.issue_notification({
        :type => :error,
        :text => tr("Network error")
      })
		end		
			
		# HTTP Request send method, checks if a connection to the Internet is present
		def send_test_request
			dispatch_request({ 
				:url => "http://www.example.com/", # IANA (192.0.32.10) ftw !
				:operation => :head, 
				:repeat => true,
				:error_handler => lambda { |error| no_connection(error) }
			}) 
		end
		
		# Utility method, wrapper for the creation of a new HTTP request for the given URL
		def request_for_url(p_url)
			Qt::NetworkRequest.new(Qt::Url.new(p_url))
		end
		
end # class NetworkConnectivityController