class Addresses < ActiveRecord::Migration
  def self.up
    create_table 'addresses', force: true do |t|
      t.string   'name'
      t.text     'address'
      t.integer  'user_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end

  def self.down
    drop_table 'addresses'
  end
end
