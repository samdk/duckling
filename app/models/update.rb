class Update < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :activation, counter_cache: true
  
  has_many :comments
  has_many :file_uploads
  
  # TODO: too long titles will break UI, too long body will slow down database.
  # These limits should be sufficient.
  
  validates :title, presence: true, length: { within: 2..1000 }
  validates :body, presence: true, length: { within: 2..100_000 }
end
