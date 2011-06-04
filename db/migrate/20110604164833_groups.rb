class Groups < ActiveRecord::Migration
  def self.up
    create_table 'groups', force: true do |t|
      t.string   'name'
      t.string   'description'
      t.integer  'groupable_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string   'groupable_type'
    end
  end

  def self.down
    drop_table 'groups'
  end
end
