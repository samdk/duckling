class Organization < ActiveRecord::Base
  is_soft_deleted
  
  has_many :users
  
  has_many :administratorships, dependent: :destroy
  has_many :administrators,     class_name: 'User'
  
  has_many :managerships,       dependent: :destroy
  has_many :managers,           class_name: 'User'
  
  has_many :sections
  
  validate :has_at_least_one_administrator
  def has_at_least_one_administrator
    if administrators.empty?
      errors.add(:administrators, 'must be present')
    end
  end
  
  validates :name, presence: true,
                   length: {minimum: 3},
                   uniqueness: true,
                   format: {with: /[A-Za-z0-9\-_]+/}
  
end
