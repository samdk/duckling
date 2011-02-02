class FileUpload < ActiveRecord::Base
  belongs_to :update
  has_attached_file :upload, FILE_STORAGE_OPTS
end
