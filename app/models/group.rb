class Group < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  
  has_and_belongs_to_many :users
end
