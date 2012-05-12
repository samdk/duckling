class Comments < ActiveRecord::Migration
  def change
    create_table 'comments' do |t|
      t.text     'body'
      t.integer  'author_id'
      t.integer  'update_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end
end
