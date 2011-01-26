class AddPrimaryAddressToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.references :primary_address
    end
  end

  def self.down
    remove_column :users, :primary_address
  end
end
