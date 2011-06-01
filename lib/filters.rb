module ActiveRecord
  class Base
    scope :in_date_range, ->(since = nil, terminus = nil, target = :created_at) {
      since, terminus = since[:from], since[:to] if Hash  === since
      
      since    ||= ''
      terminus ||= '9999-99-99 99:99:99'
      
      unless since.blank? and terminus.blank?
        where("#{target} BETWEEN ? AND ?", since, terminus)
      end     
    }
    
    scope :matching_search, ->(fields, query) {
      return unless fields.size > 0 && !query.blank?
      
      where(fields.map {|x| "#{x} ILIKE ?"}.join(' OR '), *([query]*fields.size))
    }
    
    scope :matching_joins, ->(join, ids) {
      return unless ids.size > 0
      
      joins(join).where("#{join}.id" => ids)
    }
    
    
  end
end