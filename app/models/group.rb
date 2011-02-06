class Group < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  
  has_and_belongs_to_many :users
  
  validates :name, presence: true, length: {within: 2..50}
  validates :description, length: {within: 0..50}
end
