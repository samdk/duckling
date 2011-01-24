class User < ActiveRecord::Base
  is_soft_deleted
  serialize :phone_numbers, Hash
  
  has_many :organizations
  has_many :administratorships, dependent: :destroy
  has_many :administrated_organizations, class_name: 'Organization'
  
  has_many :managerships, dependent: :destroy
  has_many :managed_organizations, class_name: 'Organization'
  
  has_many :email_addresses
  
  validates :password_hash, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  before_save do |user|
    user.phone_numbers.to_a.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
  end
  
  after_initialize do |user|
    user.phone_numbers ||= {}
  end
  
  def password
    @password ||= BCrypt::Password.new(password_hash)
  end
  
  def password=(new_pass)
    @password = BCrypt::Password.create(new_pass)
    self.password_hash = @password
  end
  
end
