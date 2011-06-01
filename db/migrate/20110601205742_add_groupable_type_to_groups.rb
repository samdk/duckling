class AddGroupableTypeToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.string :groupable_type
    end
  end

  def self.down
    remove_column :groups, :groupable_type
  end
end
