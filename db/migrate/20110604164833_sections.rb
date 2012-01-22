class Sections < ActiveRecord::Migration
  def self.up
    create_table 'sections', force: true do |t|
      t.string   'name',            limit: 50
      t.string   'description',     limit: 1000
      t.integer  'groupable_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'groupable_type'
    end
  end

  def self.down
    drop_table 'sections'
  end
end
