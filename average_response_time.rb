class AverageResponseTime
  attr_accessor :queue

  DEFAULT_POOL = 10
  WORST_COUNT = 10

  def initialize(pool = DEFAULT_POOL)
    @threads = MultiThread.new(pool)
    @queue = {}
    @times = {}
  end

  def calculate
    @queue.each_pair do |k,v|
      calculate_average(k, v)
    end
    @threads.check_all_finished
    self
  end

  def calculate_average(response_key, response_times)
    @threads.process {
      @threads.safe_write{
        @times[response_key] =  average_reponse_time(response_times)
      }
    }

  end

  def sort_desc
    @times.sort_by {|k,v| v}.reverse
  end

  def worst(count = WORST_COUNT)
    puts @times if ENV['VERBOSE'] == 'true'
    sort_desc.first(count).collect(&:first)
  end

  def average_reponse_time(array)
    array.inject(0.0) { |sum, el| sum + el } / array.size
  end

  def enqueue(key, val)
    q = @queue.clone
    q[key]  ||= []
    q[key] << val
    @queue = q
  end

end
