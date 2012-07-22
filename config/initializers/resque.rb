rails_root    = ENV['RAILS_ROOT'] || File.join(File.dirname(__FILE__), '..', '..')
rails_env     = ENV['RAILS_ENV']  || 'development'
resque_config = YAML.load_file(File.join(rails_root, 'config', 'resque.yml'))

Resque.redis = ENV['REDISTOGO_URL'] or resque_config[rails_env]
Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

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
