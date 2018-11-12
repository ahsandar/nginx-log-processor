require 'thwait'

class MultiThread

  DEFAULT_POOL = 10

  def initialize(pool = DEFAULT_POOL)
    @threads = []
    @pool = pool
  end

  def safe_write(&block)
    Mutex.new.synchronize {
      block.call if block_given?
    }
  end

  def join
    @threads.each do |thr|
      if thr.alive? && thr.status != 'sleep'
        thr.join
        @threads.delete(thr)
      end
    end
    @threads = []
  end

  def check_all_finished
    join
    ThreadsWait.all_waits(*@threads)
  end

  def process(&block)
    @threads << Thread.new {
      block.call if block_given?
    }
    if (@threads.size % @pool) == 0
      join
    end

  end

end
