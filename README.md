___
```
I have tried to write all code without helps from any Gems to keep it simple and not add clutter to code or execution.
```


___
>`Ruby 2.5.1`

`nginx_log_parser.rb`
- Class name `NginxLogParser`
- `analyze_requests` is implemented in this class.
- It reads the file given to it in a lazy method with one line at a time in memory.
- Uses a thread pool to read max lines in memory for processing.

`nginx_log_object.rb`
- Class name `NginxLogObject`
- Log object class to parse the line for extracting required information.

`multi_thread`
- Class name `MultiThread`
- This class handles the thread generation and assignment and also manages the `basic` thread pool implementation required for this exercise.

`average_reponse_time`
- Class name `AverageResponseTime`
- This class handles the processing of required analysis of average response time.

`processor.rb`
- Program execution code.
- This file has the starter code, filename and threadpool size is defined in here which can be changed.
- It prints the time taken to finish the program as well which can be used to see the difference when thread pool size is tweaked.

DEFAULT_THREAD_POOL = `10`

Thread pool size can be changed based on demand to adjust speed and utilise available resources.

To execute Program
> `ruby processor.rb`

To display the hash of links with their respective avg response time can add `VERBOSE=true`
> ` VERBOSE=true ruby processor.rb`
