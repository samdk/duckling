class CreateTagsAndLinkGroups < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end
    
    create_table :tags_updates, id: false do |t|
      t.references :tag
      t.references :update
    end
    
    create_table :groups_updates, id: false do |t|
      t.references :group
      t.references :update
    end
  end

  def self.down
    drop_table :tags
    drop_table :tags_updates
    drop_table :groups_updates
  end
end
