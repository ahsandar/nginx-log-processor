class NginxLogObject
  attr_reader :url, :response_time, :response_status

  RESPONSE_STATUS_REGEX = /Status Code: (\d\d\d)/
  RESPONSE_TIME_REGEX = /(\d*\S*\d+)/
  
  #line /articles.html?id=4, 0.12s, Status Code: 200
  def initialize(line)
    parse(line)
  end

  def is_valid_for_analysis?
    is_200? && !is_gif?
  end

  def is_200?
    response_status == '200'
  end

  def is_gif?
    @url =~ /.*\.gif?.*$/
  end

  def print_valid_200
    if is_valid_for_analysis?
      puts "log_object url => #{url}"
      puts "log_object reponse_time => #{response_time}"
      puts "log_object reponse_status => #{response_status}"
    end
  end

private
  def parse(line)
    line_splits = line.split(',')
    @url = line_splits[0].downcase
    @response_time = parse_response_time line_splits[1]
    @response_status = parse_response_status line_splits[2]
  end

  def parse_response_time(time_s)
    extract_regex(time_s, RESPONSE_TIME_REGEX).to_f
  end

  def parse_response_status(r_status)
    extract_regex(r_status, RESPONSE_STATUS_REGEX)
  end

  def extract_regex(val, regex)
    val.scan(regex).flatten.first
  end

end
