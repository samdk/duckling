class Sections < ActiveRecord::Migration
  def change
    create_table 'sections' do |t|
      t.string 'name',         limit: 50
      t.string 'description',  limit: 1000
      t.references 'groupable', polymorphic: true
      t.timestamps
    end
  end
end
