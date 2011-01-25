class User < ActiveRecord::Base
  is_soft_deleted
  
  serialize :phone_numbers, Hash
  serialize :email_addresses, Array
  
  has_many :organizations
  has_many :administratorships, dependent: :destroy
  has_many :administrated_organizations, class_name: 'Organization'
  
  has_many :managerships, dependent: :destroy
  has_many :managed_organizations, class_name: 'Organization'
    
  validates :password_hash, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  before_save do |user|
    user.phone_numbers.to_a.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
  end
  
  after_initialize do |user|
    user.phone_numbers   ||= {}
    user.email_addresses ||= []
  end
  
  def password
    @password ||= BCrypt::Password.new(password_hash)
  end
  
  def password=(new_pass)
    @password = BCrypt::Password.create(new_pass)
    self.password_hash = @password
  end
  
  def password?(pass)
    password == pass
  end
  
  def self.credentials?(email, pass)
    qry = User.where('email_addresses LIKE ?', "%#{email}%")
    !! qry.select('password_hash').first.try(:password?, pass)
  end
  
  def name
    [name_prefix,first_name,last_name,name_suffix].join(' ').strip.gsub(/\s+/, ' ')
  end
  
end
