class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :activation
  
  has_many :comments
  has_many :file_uploads
end
