class User < ActiveRecord::Base
  is_soft_deleted
  
  scope :with_email, lambda { |email| 
    where('email_addresses LIKE ?', "%#{email.downcase}%")
  }
  
  has_many :addresses
  has_one :primary_address, class_name: 'Address'
  
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :administrated_organizations, class_name: 'Organization'
  has_and_belongs_to_many :managed_organizations, class_name: 'Organization'
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :sections
  
  validates :password_hash, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  validate :email_validations
  def email_validations
    if email_addresses.blank?
      errors.add(:email_addresses, 'must be present')
    end
    
    dups = email_addresses.any? do |e|
      u = User.with_email(e).first
      u && u.id != self.id
    end
    
    errors.add(:email_addresses, 'is invalid or already used') if dups
  end
  
  before_save do |user|
    user.phone_numbers.to_a.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
    
    # yay fake serialization
    user.phone_numbers = user.phone_numbers 
    user.email_addresses = user.email_addresses.map(&:downcase)
  end
  
  after_initialize do |user|
    user.phone_numbers   ||= {}
    user.email_addresses ||= []
  end
  
  def phone_numbers
    @phone_numbers ||= begin
      numbers = self['phone_numbers'] || ''
      Hash[numbers.split("\n").map{|x|x.split("\t")}]
    end
  end
  
  def phone_numbers=(new_numbers)
    self['phone_numbers'] = new_numbers.to_a.map{|x|x.join("\t")}.join("\n")
    @phone_numbers = new_numbers
  end
  
  def email_addresses
    @email_addresses ||= (self['email_addresses'] || '').split("\n")
  end
  
  def email_addresses=(new_emails)
    self['email_addresses'] = new_emails.join("\n")
    @email_addresses = new_emails
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
    !! User.with_email(email).select('password_hash').first.try(:password?, pass)
  end
  
  def name
    [name_prefix,first_name,last_name,name_suffix].join(' ').strip.gsub(/\s+/, ' ')
  end
  
end
