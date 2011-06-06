module Cacher  
  def self.included(base)
    base.extend(InstanceMethods)
  end
  
  def cache(*args, &blk)
    self.class.cache(*args, &blk)
  end
  
  module InstanceMethods
    def cache(key, opts = {})
      if not opts[:force_write] and (ids = Array(Rails.cache.read(key))).size > 0
        opts[:ids_only] ? ids : find(*ids)
      else
        returning(yield) do |models|
          Rails.cache.write(key, Array(models).map(&:id))
        end
      end
    end
  end
end
