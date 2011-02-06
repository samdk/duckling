class Activation < ActiveRecord::Base
  is_soft_deleted
  
  has_many :updates
  has_many :groups, as: :groupable
  
  has_and_belongs_to_many :organizations
  
  validates :title, presence: true, length: {within: 3..50 }
  
  def activate
    update_attributes(active: true, activation_changed_at: DateTime.now)
  end
  
  def deactivate
    update_attributes(active: false, activation_changed_at: DateTime.now)
  end
  
  def active_since
    activation_changed_at or created_at
  end
  alias_method :inactive_since, :active_since
  
end
