class CreateActivations < ActiveRecord::Migration
  def self.up
    create_table :activations do |t|
      t.string :title
      t.string :description
      t.boolean :active
      t.datetime :deleted_at

      t.timestamps
    end
  end

  def self.down
    drop_table :activations
  end
end
