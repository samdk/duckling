class Sections < ActiveRecord::Migration
  def change
    create_table 'sections' do |t|
      t.string 'name',         limit: 50
      t.string 'description',  limit: 1000
      t.timestamps
      t.references 'groupable', polymorphic: true
    end
    
    create_table 'groups' do |t|
      t.string 'name',         limit: 50
      t.string 'description',  limit: 1000
      t.timestamps
      t.references 'groupable', polymorphic: true
    end
    
  end
end
