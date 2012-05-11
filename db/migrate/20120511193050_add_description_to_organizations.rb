class AddDescriptionToOrganizations < ActiveRecord::Migration
  def change
    add_column 'organizations', 'description', :text, limit: 2500
  end
end
