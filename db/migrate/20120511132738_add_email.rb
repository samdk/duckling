class AddEmail < ActiveRecord::Migration
  def change
    create_table 'emails', force: true do |t|
      t.string 'email', limit: 256
      t.string 'state', limit: 16, default: 'unverified'
      t.references 'user'
      t.timestamps
    end
    
    add_index 'emails', 'email'
    add_index 'emails', %w[email state]
  end
end
