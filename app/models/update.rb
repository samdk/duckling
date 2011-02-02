class Update < ActiveRecord::Base
  belongs_to :user
  belongs_to :activation
  
  has_many :comments
end
