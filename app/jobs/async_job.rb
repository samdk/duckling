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
      @target = target
    end
    def method_missing(method, *args)
      if Class === target
        Resque.enqueue(AsyncJob::Performer, @target, nil, method, *args)
      else
        Resque.enqueue(AsyncJob::Performer, @target.class, @target.id, method, *args)
      end
    end
  end
  
  class Performer
    def self.perform(klass, id, *args)
      if id == nil
        klass.send *args
      else
        klass.find(id.to_i).send(*args)
      end
    end
  end
end