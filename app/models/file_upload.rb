class FileUpload < ActiveRecord::Base
  belongs_to :update, counter_cache: true
  has_attached_file :upload, FILE_STORAGE_OPTS
end
