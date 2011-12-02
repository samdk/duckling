# Load the rails application
require File.expand_path('../application', __FILE__)

APP_CONFIG = YAML.load_file(File.expand_path('../../config.yml', __FILE__))[Rails.env]

Duckling::Application.config.secret_token = APP_CONFIG['secret_token']

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

# TODO: determine if this is a nasty hack
module ActiveRecord
  class Base
    include Cacher
    
    def self.t(*args, &blk)
      I18n.t(*args, &blk)
    end
    def t(*args, &blk)
      I18n.t(*args, &blk)
    end
  end
end


# Initialize the rails application
Duckling::Application.initialize!
