class Comment < ActiveRecord::Base
  
  belongs_to :author, class_name: 'User'
  belongs_to :update, counter_cache: true
  
  validates :body, presence: true, length: { within: 2..5000 }
  
  include AuthorizedModel
  def permit_create?(user, opts)
    user.activations.where(id: opts[:activation_id]).exists?
  end
  
  def permit_read?(user, opts)
    permit_create? user, opts
  end
  
  def permit_update?(user, *)
    author == user
  end
  
  def permit_destroy?(user, opts)
    Activation.permit_administrate? opts[:activation_id], user
  end
  
end
