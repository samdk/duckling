class Comments < ActiveRecord::Migration
  def self.up
    create_table 'comments', force: true do |t|
      t.text     'body'
      t.integer  'author_id'
      t.integer  'update_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end

  def self.down
    drop_table 'comments'
  end
end
