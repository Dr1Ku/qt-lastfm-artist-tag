# Tasks.rb
require "singleton"
require "lib/qt-thread-patch/event_queue_repetition"

module QtUtils
  class Tasks
    include Singleton

    def initialize
      @tasks = Queue.new
      @tasksLock = Mutex.new
      @repetition = EventQueueRepetition.startNew {
        flush
      }
    end

    def invokeLater(&block)
      @tasksLock.synchronize {
        @tasks << block
      }
    end

    def flush
      @tasksLock.synchronize {
        while !@tasks.empty?
          @tasks.pop.call
        end
      }
    end

    def self.invokeLater(&block)
      instance.invokeLater(&block)
    end

    def self.flush
      instance.flush
    end
  end
end