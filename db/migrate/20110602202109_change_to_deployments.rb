class ChangeToDeployments < ActiveRecord::Migration
  def self.up
    drop_table :activations_organizations
    rename_table :activationships, :deployments
    
    change_table :deployments do |t|
      t.rename :user_id, :deployed_id
      t.string :deployed_type
    end
    
  end

  def self.down
    rename_table :deployments, :activationships
  end
end
