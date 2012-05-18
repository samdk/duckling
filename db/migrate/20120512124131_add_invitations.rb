class AddInvitations < ActiveRecord::Migration
  def change
    create_table 'invitations' do |t|
      t.references 'email'
      t.references 'inviter'
      t.references 'invitable', polymorphic: true
      t.boolean    'emailed', default: false
      t.timestamps
    end
    
    add_index :invitations, 'email_id'
    add_index :invitations, %w[invitable_id invitable_type]
    add_index :invitations, 'emailed'
  end
end
