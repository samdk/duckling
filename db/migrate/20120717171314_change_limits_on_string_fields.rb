class ChangeLimitsOnStringFields < ActiveRecord::Migration
  def up
    change_column :emails, :secret_code, :string, :limit => 255
    change_column :updates, :title, :string, :limit => 255
    change_column :activations, :title, :string, :limit => 255
  end

  def down
    change_column :emails, :secret_code, :string, :limit => 64
    change_column :updates, :title, :string, :limit => 128
    change_column :activations, :title, :string, :limit => 128
  end
end
