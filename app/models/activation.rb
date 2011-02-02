class Activation < ActiveRecord::Base
  is_soft_deleted
  
  has_many :updates
  has_many :groups, as: :groupable
  
  has_and_belongs_to_many :organizations
  
end
