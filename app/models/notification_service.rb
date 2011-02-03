class NotificationService
  
  def initialize(host, namespace='')
    @@redis ||= Redis.new(REDIS_SETTINGS)
    @key = "#{host.class.name.downcase}_#{namespace}_#{host.id}"
  end
  
  def size
    redis.scard @key
  end
  
  def each(&block)
    to_a.each(&block)
  end
  
  def dismissing_each
    size.times do
      yield redis.spop(@key)
    end
  end
  
  def dismiss(obj)
    redis.srem obj_key(obj)
  end
  
  def <<(obj)
    redis.sadd @key, obj_key(obj)
  end
  
  def dismiss_all
    redis.del @key
  end
  
  def to_a
    @notifications ||= reload
  end
  
  def reload
    @notifications = redis.smembers(@key).map do |k|
      klass, id = k.split(',')
      klass.constantize.find(id.to_i)
    end
  end
  
  private
  
  def obj_key(obj)
    "#{obj.class.name},#{obj.id}"
  end
  
  def redis
    @@redis
  end
    
end