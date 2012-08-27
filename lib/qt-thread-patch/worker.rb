# Worker.rb
require "lib/qt-thread-patch/event_queue_repetition"

module QtUtils
  class Worker
    @@workers = Array.new

    def initialize
      super()

      @rubyThread = Thread.new { yield }
      @@workers << self

      @repetition = EventQueueRepetition.startNew { |repetition|
        if !@rubyThread.nil? and !@rubyThread.alive?
          repetition.stop
          @@workers.delete(self)
        end
      }
    end

    def kill
      @rubyThread.kill
    end
  end
end