class JoinTables < ActiveRecord::Migration
  def self.up
    create_table 'acquaintances', id: false do |t|
      t.integer 'user_id'
      t.integer 'other_user_id'
    end
    
    create_table 'administrated_organizations_users', id: false do |t|
      t.integer 'organization_id'
      t.integer 'user_id'
    end
    
    create_table 'groups_updates', id: false do |t|
      t.integer 'group_id'
      t.integer 'update_id'
    end

    create_table 'groups_users', id: false do |t|
      t.integer 'group_id'
      t.integer 'user_id'
    end

    create_table 'managed_organizations_users', id: false do |t|
      t.integer 'organization_id'
      t.integer 'user_id'
    end
    
    create_table 'organizations_users', id: false do |t|
      t.integer 'organization_id'
      t.integer 'user_id'
    end
    
    create_table 'tags_updates', id: false do |t|
      t.integer 'tag_id'
      t.integer 'update_id'
    end
    
    create_table 'deployments', id: false do |t|
      t.integer 'activation_id'
      t.integer 'deployed_id'
      t.boolean 'active', default: true
      t.string  'deployed_type'
    end
  end

  def self.down
    %w[acquaintances administrated_organizations_users groups_updates
       groups_users managed_organizations_users organizations_users
       tags_updates deployments].each {|table| drop_table table }
  end
end
