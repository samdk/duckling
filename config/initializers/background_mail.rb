module ActionMailer
  class Base
    include AsyncJob
    
    def self.perform(method, *args)
      args.map! do |arg|
        if Hash === arg and arg.size == 1 and klass = ActiveRecord::Base.const_get(arg.keys[0].classify)
          klass.find(arg.values.first)
        else
          arg
        end
      end
            
      send(method, *args).deliver
    end
    
    def self.async
      proxy = super
      def proxy.method_missing(name, *args)
        Resque.enqueue @base, name, *args.map {|x|
            ActiveRecord::Base === x ? {x.class.name => x.id} : x
          }
      end
      proxy
    end
  end
end