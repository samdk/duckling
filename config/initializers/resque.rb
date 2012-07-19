rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env  = ENV['RAILS_ENV']  || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

module Rails
  def self.queue
    ::ResqueProxy
  end
end

class ResqueProxy
  @enabled = true
  
  def self.enabled?
    @enabled
  end
  
  def self.enable
    @enabled = true
  end
  
  def self.disable
    @enabled = false
  end
  
  def self.method_missing(*args)
    Resque.send(*args) if enabled?
  end
end