require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module Duckling
  class Application < Rails::Application

    config.autoload_paths += [File.join(config.root, 'lib'),
                              File.join(config.root, 'app', 'jobs')]
    
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    # config.time_zone = 'Central Time (US & Canada)'
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_view.javascript_expansions[:defaults] = %w[jquery rails]
    config.encoding = 'utf-8'
    config.filter_parameters += [:password, :password_hash]
    
    config.cache_store = :redis_store, {namespace: 'cache'}
  end
end
