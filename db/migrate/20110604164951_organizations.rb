class Organizations < ActiveRecord::Migration
  def self.up
    create_table 'organizations', force: true do |t|
      t.string   'name'
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end

  def self.down
    drop_table 'organizations'
  end
end
