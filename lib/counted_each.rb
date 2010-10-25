module CountedEach
  def counted_each(*args, &block)
    ::CountedEach::Counter.new(self).iterate(&block)
  end

  class Counter
    def initialize(list)
      @list = list
      @t_start = nil
    end

    def iterate(&block)
      @total = @list.count
      start
      @list.each_with_index do |item, pos|
        @current = pos
        block.call(item)
        Config.output.print "   %i/%i Elapsed: %s   Time to Complete: %s       \r" % [pos+1, @total, time_format(elapsed), time_format(to_go)]
        Config.output.flush
      end
      stop
      Config.output.puts
    end

    def start
      @t_start = Time.now
    end

    def stop
      @t_stop = Time.now
    end

    def elapsed
      Time.now - @t_start
    end

    def to_go
      (elapsed / @current) * (@total - @current)
    end

    def time_format(seconds)
      return '00:00' if seconds.infinite?
      h = (seconds/3600).floor
      m = ((seconds - (h*3600))/60).floor
      s = (seconds - (m * 60) - (h*3600)).floor
      
      "%d:%02d:%02d" % [h, m, s]
    end
  end

  Config = Class.new do
    attr_accessor :output

    def initialize
      output = STDERR
    end
  end.new

  module Util
  end
end

class Array; include CountedEach; end
