class JoinTables < ActiveRecord::Migration
  def change
    create_table 'acquaintances', id: false do |t|
      t.integer 'user_id'
      t.integer 'other_user_id'
    end

    create_table 'memberships', id: false do |t|
      t.references 'container', polymorphic: true
      t.references 'user'
      t.string  'access_level', default: ''
    end
    
    add_index 'memberships', %w[container_id container_type]
    add_index 'memberships', %w[user_id container_type]
    
    create_table 'participants', id: false do |t|
      t.references :update
      t.references :section
    end
    
    add_index 'participants', 'update_id'
    add_index 'participants', 'section_id'
        
    create_table 'deployments', id: false do |t|
      t.references 'activation'
      t.references 'deployed', polymorphic: true
      t.boolean    'active',   default: true
    end
    
    add_index 'deployments', %w[deployed_id deployed_type]
    add_index 'deployments', %w[activation_id deployed_type]
  end
end
