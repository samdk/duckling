class CreateAcquaintances < ActiveRecord::Migration
  def self.up
    create_table :acquaintances, id: false do |t|
      t.references :user
      t.references :other_user
    end
  end

  def self.down
    drop_table :acquaintances
  end
end
