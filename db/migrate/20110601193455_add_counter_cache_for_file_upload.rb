class AddCounterCacheForFileUpload < ActiveRecord::Migration
  def self.up
    change_table :updates do |t|
      t.integer :file_uploads_count
    end
  end

  def self.down
    remove_column :updates, :file_uploads_count
  end
end
