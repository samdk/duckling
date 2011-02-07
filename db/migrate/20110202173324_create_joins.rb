class CreateJoins < ActiveRecord::Migration
  def self.up
  
    create_table :organizations_users, id: false do |t|
      t.references :organizations
      t.references :users
    end
    
    create_table :administrated_organizations_users, id: false do |t|
      t.references :organizations
      t.references :users
    end
    
    create_table :managed_organizations_users, id: false do |t|
      t.references :organizations
      t.references :users
    end
    
    create_table :groups_users, id: false do |t|
      t.references :groups
      t.references :users
    end
    
  end

  def self.down
    drop_table :organizations_users
    drop_table :administrated_organizations_users
    drop_table :managed_organizations_users
    drop_table :groups_users    
  end
end