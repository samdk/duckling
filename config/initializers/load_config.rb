APP_CONFIG = YAML.load_file(File.expand_path('../config.yml', __FILE__))[ENV['RAILS_ENV']]

Duckling::Application.config.secret_token = APP_CONFIG['secret_token']

FILE_STORAGE_OPTS = if s3 = APP_CONFIG['s3']
  { secret_access_key: s3['secret_access'],
    access_key_id:     s3['access_key_id'],
    s3_protocol:       'https' } # we need more here
else
  { path: ':rails_root/attachments/:attachment/:id/:filename' }
end

FILE_STORAGE_OPTS[:url] = APP_CONFIG['file_upload_url'] || '/attachments/:attachment/:id/:filename'

REDIS_SETTINGS = if redis = APP_CONFIG['redis']
  { host: redis['host'], port: redis['port'] }
else
  { host: 'localhost', port: 6379 }
end