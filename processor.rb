require_relative 'nginx_log_parser'
FILE = 'access_log_10.log'
FILEPATH = "#{Dir.pwd}/sample_logs/#{FILE}"
THREADPOOL = 10
puts "Filepath => #{FILEPATH}"
puts "Threadpool => #{THREADPOOL}"
time_then = Time.now
NginxLogParser.new(THREADPOOL).analyze_requests(FILEPATH)
puts "Total time => #{Time.now - time_then}"
