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
        Task.create(target_type: @target.name, method: method, args: args.to_json)
      else
        Task.create(target: @target, method: method, args: args.to_json)
      end
    end
  end
  
  class Task < ActiveRecord::Base
    belongs_to :target, polymorphic: true
    serialize :args
    def perform
      arguments = JSON.parse(args)
      if target_id.to_i > 0
        target.send(method, arguments)
      else
        target_type.constantize.send(method, arguments)
      end
    end
  end
end