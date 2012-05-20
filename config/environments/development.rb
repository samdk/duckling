Duckling::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local = true
  
  config.assets.compress = false
  config.assets.debug    = true
  # config.assets.logger   = false
  
  config.action_controller.perform_caching = false

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
  
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address:              'email-smtp.us-east-1.amazonaws.com',
                                         port:                 25,
                                         user_name:            'AKIAI7EFTJY4RVB5PT4A',
                                         password:             'AntZ1wov69YqFRyLIh3uyjjCWnNmJiuqmAc7tFqihIoz',
                                         domain:               'clbt.net',
                                         authentication:       'plain',
                                         enable_starttls_auto: true }
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
