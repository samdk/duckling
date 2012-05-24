class Users < ActiveRecord::Migration
  def change
    create_table 'users' do |t|
      t.string     'first_name',         limit: 50
      t.string     'last_name',          limit: 50
      t.string     'name_prefix',        limit: 50
      t.string     'name_suffix',        limit: 50
      t.string     'avatar_file_name',   limit: 100
      t.string     'reset_token',        limit: 64
      t.string     'state',              limit: 8,  default: 'active'
      t.string     'password_hash',      limit: 100
      t.string     'cookie_token',       limit: 128
      t.string     'api_token',          limit: 64
      t.text       'phone_numbers'
      t.datetime   'cookie_token_expires_at'
      t.datetime   'created_at'
      t.datetime   'updated_at'
      t.datetime   'deleted_at'
      t.datetime   'avatar_updated_at'
      t.references 'primary_address'
      t.references 'primary_email'
      t.string     'primary_email_address'
      t.string     'time_zone', default: 'UTC'
    end
    
    add_index 'users', 'last_name'
    add_index 'users', 'cookie_token'
  end
end
