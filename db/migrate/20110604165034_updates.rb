class Updates < ActiveRecord::Migration
  def self.up
    create_table 'updates', force: true do |t|
      t.string   'title'
      t.integer  'author_id'
      t.integer  'activation_id'
      t.text     'body'
      t.integer  'comments_count'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.integer  'file_uploads_count'
    end
  end

  def self.down
    drop_table 'updates'
  end
end
