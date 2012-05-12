class Updates < ActiveRecord::Migration
  def change
    create_table 'updates' do |t|
      t.string   'title',              limit: 128
      t.references 'author'
      t.references 'activation'
      t.text     'body'
      t.integer  'comments_count'
      t.timestamps
    end
  end
end
