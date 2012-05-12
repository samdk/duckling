class Notifications < ActiveRecord::Migration
  def change
    create_table 'notifications', id: false do |t|
      t.string  'event'
      t.string  'target_class'
      t.integer 'target_id'
      t.boolean 'dismissed', default: false
      t.references 'email'
    end

    add_index 'notifications', ['email_id'], :name => 'index_notifications_on_email_id'
  end
end
