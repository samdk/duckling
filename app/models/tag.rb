class Tag < ActiveRecord::Base
  has_and_belongs_to_many :updates
  
  validates :name, presence: true, length: {within: 1..32}
end