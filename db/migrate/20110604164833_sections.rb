class Sections < ActiveRecord::Migration
  def change
    create_table 'sections' do |t|
      t.string 'name',         limit: 50
      t.string 'description',  limit: 1000
      t.references 'activation'
      t.timestamps
    end
    
    add_index 'sections', 'name'
    add_index 'sections', 'activation_id'
  end
end
