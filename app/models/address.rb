class Address < ActiveRecord::Base  
  include AsyncJob

  belongs_to :user
  
  validates :address, length: {maximum: 300},
                      presence: true
                     
  validates :name, length: {maximum: 40},
                   presence: true,
                   format: {with: /[a-zA-Z0-9\-_]+/}
                    
  
  before_save do |addr|
    addr.address = addr.address.split("\n").map(&:strip).join("\n")
  end
  
  include AuthorizedModel
  
  def permit_edit?(user, args = {})
    self.user == user
  end
  
  alias_method :permit_create?,  :permit_edit?
  alias_method :permit_destroy?, :permit_edit?
end
