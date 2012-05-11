class UpdateUserForEmail < ActiveRecord::Migration
  def up
    remove_column 'users', 'email_addresses'
    remove_column 'users', 'unverified_email_addresses'
    add_column  'users', 'primary_organization_id', :integer
    add_column  'users', 'primary_email_id', :integer
  end

  def down
    add_column 'users', 'email_addresses', :text
    add_column 'users', 'unverified_email_addresses', :text
    remove_column 'users', 'primary_organization_id'
    remove_column 'users', 'primary_email_id'
  end
end
