class Notifications < ActiveRecord::Migration
  def self.up
    create_table 'notifications', id: false, force: true do |t|
      t.string  'key'
      t.string  'target_class'
      t.integer 'target_id'
    end

    add_index 'notifications', ['key'], :name => 'index_notifications_on_key'
  end

  def self.down
    drop_table 'notifications'
  end
end
