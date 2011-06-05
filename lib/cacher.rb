module Cacher
  def cache(key, opts = {})
    if not opts[:force_write] and (ids = Array(Rails.cache.read(key))).size > 0
      opts[:ids_only] ? ids : find(*ids)
    else
      returning(yield) do |models|
        Rails.cache.write(key, Array(models).map(&:id))
      end
    end
  end
  
  def self.extended(base)
    def base.cache(*args)
      self.class.cache(*args)
    end
  end
end
