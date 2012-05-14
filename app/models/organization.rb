class Organization < ActiveRecord::Base
  include Filters
  
  include AuthorizedModel
  def permit_create?(*)
    true
  end
  
  def permit_read?(user, *)
    self.users.exists?(user.id)
  end
  
  def permit_update?(user, *)
    user && user.administrates?(self)
  end
  
  def permit_destroy?(user, *)
    false
  end

  acts_as_paranoid
  
  attr_accessible :name, :description
  
  has_many :activation_mappings, class_name: 'Mapping::ActivationOrganization', dependent: :destroy
  has_many :activations, through: :activation_mappings

  has_many :memberships, as: 'container', dependent: :destroy
  has_many :users, through: :memberships

  def interested_emails() users end

  has_many :invitations, as: :invitable, dependent: :destroy
  has_many :invited_emails, through: :invitations, class_name: 'Email', foreign_key: 'email_id'
  
  has_many :section_mappings, class_name: 'Mapping::OrganizationSection', dependent: :destroy
  has_many :sections, through: :section_mappings


  validates :name, presence: true,
                   length: {within: (3..128)},
                   uniqueness: true,
                   format: {with: /[A-Za-z0-9\-_]+/}

  validates :description, length: {maximum: 25000}
  
  def to_s
    self.name
  end
end
