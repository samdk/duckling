class JoinTables < ActiveRecord::Migration
  def self.up
    create_table 'acquaintances', id: false do |t|
      t.integer 'user_id'
      t.integer 'other_user_id'
    end
    
    create_table 'sections_updates', id: false do |t|
      t.integer 'section_id'
      t.integer 'update_id'
    end

    create_table 'sections_users', id: false do |t|
      t.integer 'section_id'
      t.integer 'user_id'
    end

    create_table 'memberships', id: false do |t|
      t.integer 'organization_id'
      t.integer 'user_id'
      t.string  'access_level', default: ''
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
    %w[acquaintances administrated_organizations_users sections_updates
       sections_users managed_organizations_users organizations_users
       tags_updates deployments].each {|table| drop_table table }
  end
end
