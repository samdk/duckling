class Activation < ActiveRecord::Base  
  acts_as_paranoid
  include Filters
  
  has_many :updates
  has_many :sections
  
  has_many :organization_mappings, class_name: 'Mapping::ActivationOrganization', dependent: :destroy
  has_many :organizations, through: :organization_mappings

  has_many :invitations, as: 'invitable', dependent: :delete_all

  has_many :memberships, as: 'container', dependent: :destroy
  has_many :users, through: :memberships
  
  validates :title, presence: true, length: { within: 3..128 }
  validates_length_of :description, maximum: 8000

  def interested_emails
    users
  end
  
  include AuthorizedModel
  def permit_create?(user, *)
    true
  end
  
  def permit_read?(user, *)
    !user.blank? and users.exists?(user.id)
  end
  
  def permit_update?(user, *)
    permit_read? user
  end
  
  def permit_destroy?(user, *)
    created_at < 5.minutes.ago and permit_read? user
  end
  
  def self.permit_administrate?(id, user)
    true
  end

  def activate
    update_attributes(active: true, active_or_inactive_since: DateTime.now)
  end

  def deactivate
    update_attributes(active: false, active_or_inactive_since: DateTime.now)
  end

  def active_since
    active_or_inactive_since or created_at
  end
  alias_method :inactive_since, :active_since

  def to_s() title end
end
