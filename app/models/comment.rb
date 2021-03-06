class Comment < ActiveRecord::Base
  
  belongs_to :author, class_name: 'User'
  belongs_to :update, counter_cache: true

  has_one :attachment, as: :attachable, dependent: :destroy
  attr_accessible :attachment_attributes
  accepts_nested_attributes_for :attachment

  validates :body, presence: true, length: { within: 2..5000 }
  validates_associated  :author, :update
  validates_presence_of :author, :update

  attr_accessible :attachment, :body, :update
  
  include AuthorizedModel
  def permit_create?(user, *)
    user.activations.exists?(update.activation_id)
  end
  
  def permit_read?(user, opts)
    permit_create? user, opts
  end
  
  def permit_update?(user, *)
    author == user
  end
  
  def permit_destroy?(user, *)
    Activation.permit_administrate? update.activation_id, user
  end
  
  def interested_emails
    update.interested_emails
  end
end
