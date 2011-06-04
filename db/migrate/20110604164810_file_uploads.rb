class FileUploads < ActiveRecord::Migration
  def self.up
    create_table 'file_uploads', force: true do |t|
      t.integer  'update_id'
      t.string   'upload_file_name'
      t.string   'upload_content_type'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end

  def self.down
    drop_table 'file_uploads'
  end
end
