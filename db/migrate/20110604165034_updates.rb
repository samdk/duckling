class Updates < ActiveRecord::Migration
  def self.up
    create_table 'updates', force: true do |t|
      t.string   'title',              limit: 128
      t.integer  'author_id'
      t.integer  'activation_id'
      t.text     'body',               limit: 100_000
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
