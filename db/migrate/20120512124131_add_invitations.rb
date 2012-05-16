class AddInvitations < ActiveRecord::Migration
  def change
    create_table 'invitations' do |t|
      t.references 'email'
      t.references 'inviter'
      t.references 'invitable', polymorphic: true
      t.timestamps
    end
    
    add_index :invitations, 'email_id'
    add_index :invitations, %w[invitable_id invitable_type]
  end
end
