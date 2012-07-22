Duckling::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.action_dispatch.x_sendfile_header = nil # "X-Sendfile"
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  
  config.serve_static_assets = false
  # config.action_controller.asset_host = "http://assets.example.com"
  config.assets.initialize_on_precompile = false
  
  # config.action_mailer.raise_delivery_errors = false
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
