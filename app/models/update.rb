class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :activation, counter_cache: true
  
  has_many :comments
  has_many :file_uploads
  
  validates :title, presence: true, length: { within: 2..50 }
  validates :body, presence: true, length: { within: 2..10000 }
end
