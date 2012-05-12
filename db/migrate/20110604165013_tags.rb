class Tags < ActiveRecord::Migration
  def change
    create_table 'tags', force: true do |t|
      t.string 'name', limit: 32
    end
  end
end
