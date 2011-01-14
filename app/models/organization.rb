class Organization < ActiveRecord::Base
  is_soft_deleted
  
  has_many :administratorships, dependent: :destroy
  has_many :administrators,     dependent: :destroy, class_name: 'User'
  
  has_many :managerships,       dependent: :destroy
  has_many :managers,           dependent: :destroy, class_name: 'User'
  
  validate :has_at_least_one_administrator
  def has_at_least_one_administrator
    if administrators.empty?
      errors.add(:administrators, 'must be present')
    end
  end
  
end
