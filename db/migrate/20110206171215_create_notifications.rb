class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications, id: false do |t|
      t.string   :key
      
      t.string   :target_class
      t.integer  :target_id
    end
    
    add_index :notifications, :key
  end

  def self.down
    drop_table :notifications
  end
end
