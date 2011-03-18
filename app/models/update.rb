class Update < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :activation, counter_cache: true
  
  has_many :comments
  has_many :file_uploads
  
  # TODO: change/remove upper limits on these?
  # there's nothing more obnoxious than poorly-defined,
  # arbitary, unnecessary limits on the amount of text
  # you're allowed to enter into a field
  validates :title, presence: true, length: { within: 2..50 }
  validates :body, presence: true, length: { within: 2..10000 }
end
