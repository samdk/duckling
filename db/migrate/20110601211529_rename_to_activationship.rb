class RenameToActivationship < ActiveRecord::Migration
  def self.up
    rename_table :activations_users, :activationships
    change_table :activationships do |t|
      t.boolean :active, default: true
    end
  end

  def self.down
    remove_column :activationships, :active
    rename_table :activationships, :activations_users
  end
end
