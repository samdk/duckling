Duckling::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.action_dispatch.x_sendfile_header = nil # "X-Sendfile"
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  
  config.serve_static_assets = false
  # config.action_controller.asset_host = "http://assets.example.com"
  
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'duckling.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address:              'email-smtp.us-east-1.amazonaws.com',
                                         port:                 465,
                                         user_name:            'AKIAI7EFTJY4RVB5PT4A',
                                         password:             'AntZ1wov69YqFRyLIh3uyjjCWnNmJiuqmAc7tFqihIoz',
                                         domain:               'clbt.net',
                                         authentication:       'plain',
                                         enable_starttls_auto: true }
  
end
