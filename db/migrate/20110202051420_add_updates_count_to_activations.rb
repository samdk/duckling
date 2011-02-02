class AddUpdatesCountToActivations < ActiveRecord::Migration
  def self.up
    change_table :activations do |t|
      t.integer :updates_count
    end
  end

  def self.down
    remove_column :activations, :updates_count
  end
end
