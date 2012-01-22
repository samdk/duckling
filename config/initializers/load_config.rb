module ActiveRecord
  class Base
    include Cacher
    
    def self.t(*args, &blk)
      I18n.t(*args, &blk)
    end
    def t(*args, &blk)
      I18n.t(*args, &blk)
    end
  end
end