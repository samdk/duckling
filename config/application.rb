require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'abstract_controller/rendering'

if defined? Bundler
  Bundler.require :default, :assets, Rails.env
end

APP_CONFIG = YAML.load_file(File.expand_path('../config.yml', __FILE__))[Rails.env]

FILE_STORAGE_OPTS = if s3 = APP_CONFIG['s3']
  { secret_access_key: s3['secret_access'],
    access_key_id:     s3['access_key_id'],
    s3_protocol:       'https' } # we need more here
else
  { path: ':rails_root/attachments/:attachment/:id/:style/:filename' }
end

FILE_STORAGE_OPTS[:url] = APP_CONFIG['file_upload_url'] || '/attachments/:id'

REDIS_SETTINGS = APP_CONFIG['redis']
USE_SECURE_COOKIES = !!APP_CONFIG['secure_cookies']


module Duckling
  class Application < Rails::Application
    config.secret_token = APP_CONFIG['secret_token']
    config.autoload_paths += [File.join(config.root, 'lib'),
                              File.join(config.root, 'app', 'jobs'),
                              File.join(config.root, 'app', 'observers')]

    config.active_record.observers = [:event_observer, :joining_observer, :acquaintances_observer, :invitation_observer]
    
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_view.javascript_expansions[:defaults] = %w[jquery rails]
    config.encoding = 'utf-8'
    config.filter_parameters += [:password, :password_hash, :api_token, :secret_code]
    config.assets.enabled = true
    config.assets.version = '0.1'
    config.time_zone = 'UTC'
  end
end
