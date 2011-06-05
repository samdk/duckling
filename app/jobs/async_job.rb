module AsyncJob
  def self.included(base)
    base.extend ClassMethods
  end
  
  def async
    AsyncJob::Proxy.new(self.class, id)
  end
  
  module ClassMethods
    def async
      AsyncJob::Proxy.new(self)
    end
    
    def perform(id_or_method, *args)
      if id_or_method.to_i > 0
        find(id_or_method).send(*args)
      else
        send(id_or_method, *args)
      end
    end
    
    def queue
      :async
    end
  end 
  
  class Proxy    
    def initialize(base, id=nil)
      @base, @id = base, id
    end
  
    def method_missing(name, *args)
      if @id
        Resque.enqueue(@base, @id, name, *args)
      else
        Resque.enqueue(@base, name, *args)
      end
      true
    end
  end
end