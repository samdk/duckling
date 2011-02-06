class AddActivationTimestamps < ActiveRecord::Migration
  def self.up
    change_table :activations do |t|
      t.datetime :activation_changed_at
    end
  end

  def self.down
    remove_column :activations, :activation_changed_at
  end
end
