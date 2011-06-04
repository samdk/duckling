class Address < ActiveRecord::Base  
  include AuthorizedModel

  belongs_to :user
  
  validates :address, length: {maximum: 300},
                      presence: true
                     
  validates :name, length: {maximum: 40},
                   presence: true,
                   format: {with: /[a-zA-Z0-9\-_]+/}
                    
  
  before_save do |addr|
    addr.address = addr.address.split("\n").map(&:strip).join("\n")
  end
  
  def permit_edit?(user, args = {})
    self.user == user
  end
  
  def permit_create?(user, args = {})
    self.user == user
  end
end
