class Activation < ActiveRecord::Base
  is_soft_deleted
  
  has_many :updates
  has_many :sections
  
end
