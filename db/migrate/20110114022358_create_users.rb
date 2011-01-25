class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :name_prefix
      t.string :name_suffix
      t.text :phone_numbers
      t.text :email_addresses
      t.datetime :deleted_at
      t.string :password_hash, limit: 100

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
