class Tifi
  attr_accessible :should_shutdown, :sleep_time, :task
  def shutdown?() @should_shutdown        end
  def shutdown()  @should_shutdown = true end

  def initialize
    @should_shutdown = false
    @sleep_time      = 5.0
  end
    
  def run
    register_signal_handlers
      
    loop do
      while !shutdown? and @task.nil?
        pause
        find_task
      end
      
      break if shutdown?
      
      if child = Kernel.fork
        procline "Forked #{@child.} at #{Time.now.to_i}"
        Process.wait(child)
      else
        procline "Processing #{task.to_s} since #{Time.now.to_i}"
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
      email = user.primary_email_address
    end
      
    log "Processing #{first_notification.to_log}"

    first_notification.touch
    return if email.too_recently_emailed? || shutdown?
      
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
  
  def send_email
    raise 'todo'
  end
    
  def pause() sleep @sleep_time end
    
  def log(message)
    time = Time.now.strftime('%H:%M:%S %Y-%m-%d')
    puts "** [#{time}] #{$$}: #{message}"
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