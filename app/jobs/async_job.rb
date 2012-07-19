class ActiveRecord::Base
  def async
    AsyncJob::Proxy.new(self)
  end

  class << self
    def async
      AsyncJob::Proxy.new(self)
    end
  end
end

module AsyncJob
  class Proxy
    def initialize(target)
      @target_class, @target_id = if Class === target
        [target.name, nil]
      else
        [target.class.name, target.id]
      end
    end
    def method_missing(method, *args)
      args.map! &:to_json
      Rails.queue.enqueue(AsyncJob::Performer, @target_class, @target_id, method, *args)
    end
  end
  
  class Performer
    @queue = :default
    def self.perform(klass_name, id, *args)
      klass = klass_name.constantize
      if id.nil?
        klass.send *args
      else
        klass.find(id.to_i).send(*args)
      end
    end
  end
end