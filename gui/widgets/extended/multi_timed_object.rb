# A MultiTimedObject includes more Qt::Timers which act as a
# poor man's threads for Qt -- Ruby's native Thread implementation,
# (thread.rb), as well as the fastthread gem seem to block the GUI,
# as they are executed within Qt's main event (GUI) loop / thread.
class MultiTimedObject < Qt::Object

  # Public declarations
  public

    # Constructor, calls base and initializes fields
    def initialize(p_parent)
      super(p_parent)

      # Initialize timer container
      @@timers = { :stopped => false, :current => nil, :collection => [] }
    end

    # Creates a Qt Timer (a poorman's Qt-ready Thread).
    #
    # Arguments: sym -- The symbol to identifier the timer by,
    #
    #            auto_start -- Is the timer to be started after creation? (Default true) [Optional]
    #            one_shot -- Is the timer is only to be executed once? (Default true) [Optional]
    #            interval -- The tick interval for the timer (Default 0ms), in ms [Optional]
    def create_timer(p_args)

      # Recalibrate arguments
      p_args[:one_shot] = true if p_args[:one_shot].nil?
      p_args[:auto_start] = true if p_args[:auto_start].nil?
      p_args[:interval] ||= 0

      # Create a new Timer, store actual object, identifier and stoppable
      new_timer = Qt::BasicTimer.new
      @@timers[:current] = { :obj => new_timer, :sym => p_args[:sym], :one_shot => p_args[:one_shot] }
      @@timers[:collection] << @@timers[:current]

      # Start the newly created timer
      new_timer.start(p_args[:interval], self) if p_args[:auto_start]
    end

    # Main Timer handler, checks if the event's sender is the currently running
    # timer. If so, forwards the event to the handler.
    def timerEvent(p_event)

      # Only process if a TimerEvent was posted and timer handlers are enabled
      return unless p_event.is_a?(Qt::TimerEvent)
      return if @@timers[:stopped]

      # Store reference to current timer, skip if not present
      current_timer = @@timers[:current]
      return if current_timer.nil?

      # Check if the current timer is the one posted by the event
      current_timer_obj = current_timer[:obj]
      if p_event.timerId == current_timer_obj.timerId

        # If found, running and stop is allowed, stop.
        current_timer_obj.stop if current_timer_obj.isActive && current_timer[:one_shot]

        # Since one-shot timers have to be processed as well, call
        # the process method. Use stop_current_time when finished.
        process_timer(current_timer[:sym])
      end
    end # timer Event

    # Stops the currently running Timer
    def stop_current_timer

      # Store current timer, stop it
      current_timer = @@timers[:current]
      unless current_timer.nil?
        current_timer[:obj].stop
        @@timers[:current] = nil
      end
    end

  # Private declarations
  private

    # Handler class for a given timer, identified by a given symbol.
    # Remember to override this method within your superclass.
    def process_timer(p_sym)
      # Do nothing, should be overriden
      puts "MultiTimedObject's process_timer called, did you forget to override?"
    end

end # class MultiTimedObject