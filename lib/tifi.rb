class Tifi
  attr_accessor :should_shutdown, :sleep_time
  def shutdown?() @should_shutdown        end
  def shutdown()  @should_shutdown = true end

  def initialize(opts)
    @should_shutdown = false
    @sleep_time      = opts[:sleep_time] || 5.0
    @debug           = opts[:debug] || false
    
    if @debug
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
  end

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
    loop do
      while !shutdown? and @task.nil?
        debug "looking for task"
        pause
        find_task
      end
      
      break if shutdown?
      
      if child = Kernel.fork
        procline "Forked #{@child} at #{Time.now.to_i}"
        Process.wait(child)
      else
        procline "Processing #{@task.to_s} since #{Time.now.to_i}"
        safely_perform_task
      end
      
      @task = nil
    end
  end
    

  private
  
  def find_task
    @task = Notification.order('updated_at ASC')
                        .where(emailed: false)
                        .includes(:email)
                        .first
  end
  
  def safely_perform_task
    begin
      perform_task
    rescue Exception => e
      log "Exception:\n#{e.to_s}\n#{e.backtrace.join("\n")}"
    end
  end
    
  def perform_task
    email = @task.email

    unless (user = email.user).nil?
      debug "Task for user #{user.id}"
      email = user.primary_email_address
    end
      
    log "Processing #{@task.to_log}"

    if email.too_recently_emailed? || shutdown?
      @task.touch
      return
    end

    notifications = email.notifications
                         .where(emailed: false, dismissed: false)
                         .order('updated_at ASC')

    Notification.transaction do
      notifications.update_all(emailed: true)
      email.update_attributes emailed_at: Time.now, annoyance_level: email.annoyance_level+1

      raise ActiveRecord::Rollback, "Daemon shutdown" if shutdown?

      send_email email, notifications
    end
  end
  
  def send_email(email, notifications)
    puts "Sending email to #{email}:"
    puts notifications.map {|x| "\t#{x.to_email_string}"}.join("\n")
  end
    
  def pause() sleep sleep_time end
    
  def log(message)
    time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
    puts "** [#{time}] #{$$}: #{message}"
  end
  
  def debug(message)
    log message if @debug
  end
    
  def procline(message)
    $0 = "tifi #{$$}: #{message}"
    log "procline -> #{message}"
  end

  def register_signal_handlers
    trap('TERM') { shutdown }
    trap('INT')  { shutdown }
    trap('QUIT') { shutdown }
  end 
end