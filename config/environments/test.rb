Duckling::Application.configure do

  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions   = true
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  
  config.cache_store = :memory_store
  
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"
  config.assets.allow_debugging = true
end
