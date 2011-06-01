class Group < ActiveRecord::Base
  include Filters
  belongs_to :groupable, polymorphic: true
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :updates
  
  validates :name, presence: true, length: {within: 2..50}
  validates :description, length: {within: 0..50}
end
