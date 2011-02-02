class CreateFileUploads < ActiveRecord::Migration
  def self.up
    create_table :file_uploads do |t|
      t.references :update
      t.string :upload_file_name
      t.string :upload_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :file_uploads
  end
end
