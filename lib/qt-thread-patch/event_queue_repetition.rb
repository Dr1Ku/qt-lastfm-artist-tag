# EventQueueRepetition.rb
module QtUtils
  class EventQueueRepetition

    def self.startNew(&block)
      new(&block).qtImplementor
    end

    attr_reader :qtImplementor

    def initialize(once = false, &block)
      @qtImplementor = QtImplementor.new(once, block)
    end

    class QtImplementor < Qt::Object
      slots 'runAsEvent()'

      def runAsEvent()
        @block.call(self)
        Thread.pass
      end

      def stop
        @timer.stop
      end

      def initialize(once, block)
        super()
        @block = block
        @timer = Qt::Timer.new()
        @timer.interval = 5
        @timer.singleShot = once
        connect(@timer, SIGNAL('timeout()'), self, SLOT('runAsEvent()'))
        @timer.start
      end
    end
  end
end