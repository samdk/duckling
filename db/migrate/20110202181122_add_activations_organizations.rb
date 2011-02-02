class AddActivationsOrganizations < ActiveRecord::Migration
  def self.up
    create_table :activations_organizations, id: false do |t|
      t.references :activation
      t.references :organization
    end
  end

  def self.down
    drop_table :activations_organizations
  end
end
