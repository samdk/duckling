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
    Bullet.enable = false
    # Bullet.alert = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.disable_browser_cache = true
  end
  
  config.cache_store = :memory_store #:redis_store, {db: 1, namespace: 'cache', marshalling: false}
  
  config.assets.logger = Logger.new('/dev/null')
end



module ActiveSupport
  class BufferedLogger    
    def shout(*msgs)
      for msg in msgs
        add(0, "\033[41m\033[1;37m\n\n#{msg}\n\033[0m\033[40m\n\n")
      end
    end
  end
end