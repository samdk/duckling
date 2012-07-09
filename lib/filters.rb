module Filters
  def self.included(base)
    base.class_eval {
      scope :in_date_range, ->(since = nil, terminus = nil, target = 'created_at') {
        since, terminus = since[:from], since[:to] if Hash  === since
        
        since    ||= ''
        terminus ||= '9999-99-99 99:99:99'
        
        where("#{target} BETWEEN ? AND ?", since, terminus)
      }
      
      scope :matching_search, ->(fields, query) {
        return if fields.blank? || query.blank?
        
        query_args = ["%#{query}%"]*fields.size
        
        where(fields.map {|x| "LOWER(#{x}) LIKE LOWER(?)"}.join(' OR '), *query_args)
      }
      
      scope :matching_joins, ->(join, ids) {
        return if ids.blank?
        puts "\n\n\n\n#{join}\n#{ids}\n\n\n\n"
        joins(join).where("#{join}.id" => ids)
      }
    }
  end
end
