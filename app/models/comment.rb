class Comment < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :update, counter_cache: true
  
  validates :body, presence: true, length: { within: 2..512 }
end
