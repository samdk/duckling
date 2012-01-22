module Cacher  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def caching(*args, &blk)
    self.class.caching(*args, &blk)
  end
  
  module ClassMethods 
    def caching(key, opts = {})  
      if not opts[:force] and (ids = Array(Rails.cache.read(key))).size > 0
        Rails.logger.debug("CACHE HIT: #{key} => #{ids.inspect}") 
        ids = ids.compact
        if opts[:ids_only]
          ids
        elsif not ids.blank?
          find(*ids)
        end
      else
        Rails.logger.debug("CACHE MISS: #{key}") 
        yield.tap do |models|
          Rails.cache.write(key, Array(models).map(&:id)) unless models.blank?
        end
      end
    end
  end
end
