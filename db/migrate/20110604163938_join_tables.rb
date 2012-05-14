class JoinTables < ActiveRecord::Migration
  def change
    create_table 'acquaintances', id: false do |t|
      t.references :user
      t.references :other_user
    end
    add_index 'acquaintances', 'user_id'
    add_index 'acquaintances', 'other_user_id'

    create_table 'memberships' do |t|
      t.references 'container', polymorphic: true
      t.references 'user'
      t.string  'access_level', default: ''
    end
    add_index 'memberships', %w[container_id container_type]
    add_index 'memberships', %w[user_id container_type]
    
    create_table 'organizations_sections' do |t|
      t.references :organization
      t.references :section
    end
    add_index 'organizations_sections', 'organization_id'
    add_index 'organizations_sections', 'section_id' 
    
    create_table 'activations_organizations' do |t|
      t.references :organization
      t.references :activation
    end
    add_index 'activations_organizations', 'organization_id'
    add_index 'activations_organizations', 'activation_id'
  
    create_table 'sections_updates' do |t|
      t.references :update
      t.references :section
    end
    add_index 'sections_updates', 'update_id'
    add_index 'sections_updates', 'section_id'
  end
end
