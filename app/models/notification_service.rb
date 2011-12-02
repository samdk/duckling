module NotificationService
  def Base
    REDIS_SETTINGS.nil? ? SQLBacking : RedisBacking
  end
  
  class SQLBacking
    def initialize(host, namespace='')
      @key = "#{host.class.name.downcase}_#{namespace}_#{host.id}"
    end
    
    def size
      Notification.keyed(@key).count
    end
    
    def each(&block)
      Notification.keyed(@key).each(&block)
    end
    
    def dismissing_each
      each do |n|
        yield n
        n.destroy
      end
    end
    
    def dismiss(obj)
      Notification.keyed(@key).where(target_id: obj.id,
                                     target_class: obj.class.name).destroy
    end
    
    def <<(obj)
      Notification.create(key: @key,
                          target_id: obj.id,
                          target_class: obj.class.name)
    end
    
    def dismiss_all
      Notification.destroy_all(key: @key)
    end
    
    def to_a
      Notification.keyed(@key).all
    end
  end
  
  class Notication < ActiveRecord::Base
    set_table_name :notifications
    
    scope :keyed, lambda {|key| where(key: key) }
    
    def reference
      target_class.constantize.find(target_id)
    end
  end
  
  class RedisBacking
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
end