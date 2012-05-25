class Tifi
  def initialize(opts)
    @should_shutdown = false
    @sleep_time      = opts[:sleep_time] || 5.0
    @debug           = opts[:debug] || false
    @task_counter    = 0

    ActiveRecord::Base.logger = Logger.new(STDOUT) if @debug
  end
  
  delegate :log, :debug, to: Tifi
  attr_accessor :should_shutdown, :sleep_time
  
  def shutdown?() @should_shutdown end
  def shutdown
    log "Shutting down"
    @should_shutdown = true
  end

  def tasks() @tasks ||= [] end

  def run(opts = {})
    log "starting tifi"

    if opts[:daemonize]
      Process.daemon(true)
      log "daemonizing"
    end
    
    register_signal_handlers
    
    begin
      start_loop
    rescue Exception => e
      log "Exception:\n#{e.to_s}\n#{e.backtrace.join("\n")}"
      pause
      retry
    end
  end
  
  def start_loop   
    until shutdown?
      perform_iteration
      pause
    end
  end
  
  private

  def perform_iteration
    child = Kernel.fork do
      procline "Processing #{@task_counter} since #{Time.now.to_i}"
      safely_perform_task
    end

    procline "Forked #{child} at #{Time.now.to_i}"
    @task_counter += 1
    Process.wait(child)
  end

  def safely_perform_task
    begin
      tasks[@task_counter % tasks.size].perform
    rescue Exception => e
      log "Exception:\n#{e.to_s}\n#{e.backtrace.join("\n")}"
    end
  end

  def pause()
    5.times do
      sleep sleep_time/5.0 unless shutdown?
    end
  end
    
  def procline(message)
    $0 = "tifi #{$$}: #{message}"
  end

  def register_signal_handlers
    trap('TERM') { shutdown }
    trap('INT')  { shutdown }
    trap('QUIT') { shutdown }
  end 
  
  def self.log(message)
    time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
    puts "#{time} #{$$}: #{message}"
  end
  
  def self.debug(message)
    log "* #{message}" if @debug
  end
  
end