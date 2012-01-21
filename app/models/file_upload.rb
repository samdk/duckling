class FileUpload < ActiveRecord::Base
  belongs_to :update, counter_cache: true
  
  has_attached_file :upload, FILE_STORAGE_OPTS
  validates :upload_file_name, presence: true, length: {maximum: 128}
  
  include AuthorizedModel
  delegate :permit_create?, :permit_read?, :permit_update?, :permit_destroy?, to: :update

end
