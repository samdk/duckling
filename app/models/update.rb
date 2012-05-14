class Update < ActiveRecord::Base
  include Filters

  belongs_to :author, class_name: 'User'
  belongs_to :activation, counter_cache: true
  
  has_many :comments

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments

  has_many :section_mappings, class_name: 'Mapping::SectionUpdate', dependent: :destroy
  has_many :sections, through: :section_mappings
  
  # Too long titles will break UI, too long body will slow down database.
  # These limits should be sufficient.
  validates :title, presence: true, length: { within: 2..128 }
  validates :body,  presence: true, length: { within: 2..100_000 }

  validates_presence_of :author
  
  include AuthorizedModel
  def permit_create?(user, opts = {})
    activation.permit_read? user, opts
  end
  
  def permit_read?(user, *)
    user.activations.exists?(activation_id)
  end
  
  def permit_update?(user, *)  
    author == user or permit_administrate?(user)
  end
  
  def permit_destroy?(user, *)
    permit_update? user
  end
  
  def permit_administrate?(user, *)
    true # TODO: what should this be?
  end
  
  def interested_emails
    activation.interested_emails
  end
end
