class AddEmail < ActiveRecord::Migration
  def change
    create_table 'emails', force: true do |t|
      t.string 'email', limit: 256
      t.string 'state', limit: 16, default: 'unverified'
      t.references 'user'
      t.timestamps
      t.datetime :emailed_at
      t.integer :annoyance_level, default: 0
    end
    
    add_index 'emails', 'user_id'
    add_index 'emails', 'email'
    add_index 'emails', %w[email state]
  end
end
