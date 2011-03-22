class AddActivationsUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :activations_users, id: false do |t|
      t.references :activation
      t.references :user
    end
  end

  def self.down
    drop_table :activations_users
  end
end
