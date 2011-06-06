class Users < ActiveRecord::Migration
  def self.up
    create_table 'users', force: true do |t|
      t.string   'first_name',         limit: 50
      t.string   'last_name',          limit: 50
      t.string   'name_prefix',        limit: 50
      t.string   'name_suffix',        limit: 50
      t.string   'avatar_file_name',   limit: 100
      t.string   'reset_token',        limit: 64
      t.string   'state',              limit: 8
      t.string   'password_hash',      limit: 100
      t.string   'cookie_token',       limit: 128
      t.text     'phone_numbers'
      t.text     'email_addresses'
      t.text     'unverified_email_addresses'
      t.datetime 'cookie_token_expires_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.datetime 'deleted_at'
      t.datetime 'avatar_updated_at'
      t.integer  'primary_address_id'
    end
  end

  def self.down
    drop_table 'users'
  end
end
