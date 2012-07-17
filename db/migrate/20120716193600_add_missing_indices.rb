class AddMissingIndices < ActiveRecord::Migration
  def change
    c = ActiveRecord::Base.connection

    c.tables.each do |t|  
      columns = c.columns(t).map(&:name).select {|x| x.ends_with?("_id") || x.ends_with?("_type") }
      indexed_columns = c.indexes(t).map(&:columns).flatten

      for col in columns - indexed_columns
        add_index t, col
      end
    end

  end
end
