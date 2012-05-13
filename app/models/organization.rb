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
  
  has_many :deployments, as: :deployed

  has_many :activations, through: :deployments
  has_many :current_activations, through: :deployments, conditions: {active: true}
  has_many :past_activations, through: :deployments, conditions: {active: false}

  has_many :memberships, as: 'container'
  has_many :users, through: :memberships

  has_many :invitations, as: :invitable
  has_many :invited_emails, through: :invitations, class_name: 'Email', foreign_key: 'email_id'

  has_many :managers, class_name: 'User',
                      through: :memberships,
                      source: :user,
                      conditions: {'memberships.access_level' => 'manager'},
                      before_add: ->(*){ raise 'Do not add through this' }
  
  has_many :administrators, class_name: 'User',
                            through: :memberships,
                            source: :user,
                            conditions: {'memberships.access_level' => 'admin'},
                            before_add: ->(*){ raise 'Do not add through this' }

  has_many :groups, as: :groupable
  
  has_many :mappings, class_name: 'Section::Mapping', as: :subentity
  has_many :sections, through: :mappings

  validate :has_at_least_one_administrator, on: :update
  def has_at_least_one_administrator
    if administrators.empty?
      errors.add(:administrators, 'must be present')
    end
  end
  
  validates :name, presence: true,
                   length: {within: (3..128)},
                   uniqueness: true,
                   format: {with: /[A-Za-z0-9\-_]+/}

  validates :description, length: {maximum: 25000}
  
  def to_s
    self.name
  end
end
