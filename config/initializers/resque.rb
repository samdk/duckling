rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env  = ENV['RAILS_ENV']  || 'development'

ENV["REDISTOGO_URL"] ||= "redis://redistogo:b0d58ebc947df9ed5f4f57ed741350df@chubb.redistogo.com:9501/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

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
