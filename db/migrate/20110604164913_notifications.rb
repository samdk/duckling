class Notifications < ActiveRecord::Migration
  def change
    create_table 'notifications' do |t|
      t.string  'event'
      t.string  'target_class'
      t.integer 'target_id'
      t.boolean 'dismissed', default: false
      t.boolean 'emailed',   default: false
      t.references 'email'
      t.timestamps
    end

    add_index 'notifications', 'email_id'
    add_index 'notifications', %w[target_class target_id]
  end
end
