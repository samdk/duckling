class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :update, counter_cache: true
  
  validates :body, presence: true, length: { within: 2..512 }
end
