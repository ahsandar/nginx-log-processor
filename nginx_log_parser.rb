require_relative 'nginx_log_object'
require_relative 'multi_thread'
require_relative 'average_response_time'

class NginxLogParser

  DEFAULT_POOL = 10
  WORST_COUNT = 10

  def initialize(pool = DEFAULT_POOL, analysis = AverageResponseTime.new)
    @threads = MultiThread.new(pool)
    @analysis = analysis
  end

  def analyze_requests(filepath)
    read_file_multi_line(filepath)
    puts @analysis.calculate.worst(WORST_COUNT)
  end

  def read_file_multi_line(filepath)
    File.open(filepath) do |f|
      f.each_line.each do |l|
        multi_line_analysis(l)
      end
    end
    @threads.check_all_finished
  end

  def multi_line_analysis(line)
    @threads.process {
      log_obj = NginxLogObject.new(line)
      # log_obj.print_valid_200
      queue_response_times(log_obj) if log_obj.is_valid_for_analysis?
    }
  end

  def queue_response_times(log_obj)
    @threads.safe_write {
      @analysis.enqueue(log_obj.url, log_obj.response_time)
    }
  end

end
