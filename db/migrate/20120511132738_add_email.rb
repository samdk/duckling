class AddEmail < ActiveRecord::Migration
  def change
    create_table 'emails' do |t|
      t.string 'email',       limit: 256
      t.string 'state',       limit: 16, default: 'unverified'
      t.string 'secret_code', limit: 64
      t.references 'user'
      t.timestamps
      t.datetime :emailed_at, default: Time.new(0)
      t.integer :annoyance_level, default: 0
    end
    
    add_index 'emails', 'user_id'
    add_index 'emails', 'email'
    add_index 'emails', 'secret_code'
  end
end
