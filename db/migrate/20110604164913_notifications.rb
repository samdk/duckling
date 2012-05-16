class Notifications < ActiveRecord::Migration
  def change
    create_table 'notifications' do |t|
      t.string  'event'
      t.references 'target', polymorphic: true
      t.boolean 'dismissed', default: false
      t.boolean 'emailed',   default: false
      t.references 'email'
      t.timestamps
    end

    add_index 'notifications', 'email_id'
    add_index 'notifications', %w[target_type target_id]
  end
end
