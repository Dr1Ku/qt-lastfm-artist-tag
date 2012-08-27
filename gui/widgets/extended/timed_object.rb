# A simple wrapper for a Qt::BasicTimer
module TimedObject

  # Public declarations
  public

    # Accessible attributes
    attr_accessor :timer_duration, :timer_repeatable

    # Base initializer, remember to call in including class !
    def initialize_timer

      # Initialize timer
      @timer = Qt::BasicTimer.new

      # Initialize attributes
      @timer_duration = 2 # seconds
      @timer_repeatable = false
    end

		# Event Handler, catches the update event for
		# the created timer, stops it (is single shot)
		# and forwards the event.
		def timerEvent(p_event)
			stop_timer
    end

    # Starts the timer
    def start_timer
      @timer.start(@timer_duration * 1000, self)
    end

  # Private declarations
  private

		# Event Handler, fired when the time has elapsed,
    # usually overriden in including module
		def stop_timer

      # Only stop the timer if it's not repeatable
      @timer.stop unless @timer_repeatable
    end

end # module TimedObject