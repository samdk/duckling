class AddAvatarColumnstoUser < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_file_name,    :string
    add_column :users, :avatar_updated_at,   :datetime
  end

  def self.down
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_updated_at
  end
end
