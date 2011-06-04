class Group < ActiveRecord::Base
  include Filters
  belongs_to :groupable, polymorphic: true
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :updates
  
  validates :name, presence: true, length: {within: 2..50}
  validates :description, length: {within: 0..1000}

  def to_s
    self.name
  end
end
