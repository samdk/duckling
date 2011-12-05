Duckling::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  
  config.assets.compress = false
  config.assets.debug = true
  
  
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin
  
  Paperclip.options[:command_path] = File.dirname(`which convert`)
  
  config.after_initialize do
    Bullet.enable = false # disabled because of rails 3.1 issue
    Bullet.alert = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.disable_browser_cache = true
  end
  
  config.cache_store = :redis_store, {db: 1, namespace: 'cache'}
end


module ActiveSupport

  # Format the buffered logger with timestamp/severity info.
  class BufferedLogger
    NUMBER_TO_NAME_MAP  = {0=>'DEBUG', 1=>'INFO', 2=>'WARN', 3=>'ERROR', 4=>'FATAL', 5=>'UNKNOWN'}
    NUMBER_TO_COLOR_MAP = {0=>'0;37', 1=>'32', 2=>'33', 3=>'31', 4=>'31', 5=>'35'}

    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      sevstring = NUMBER_TO_NAME_MAP[severity]
      color     = NUMBER_TO_COLOR_MAP[severity]

      message = (message || (block && block.call) || progname).to_s
      message = "\033[0;37m#{Time.now.to_s(:db)}\033[0m [\033[#{color}m" + sprintf("%-5s","#{sevstring}") + "\033[0m] #{message.strip} (pid:#{$$})\n" unless message[-1] == ?\n
      buffer << message
      auto_flush
      message
    end
    
    def shout(*msgs)
      for msg in msgs
        add(0, "\033[41m\033[1;37m\n\n#{msg}\n\033[0m\033[40m\n\n")
      end
    end
  end
end