class Addresses < ActiveRecord::Migration
  def change
    create_table 'addresses' do |t|
      t.string   'name'
      t.text     'address'
      t.integer  'user_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end
end
