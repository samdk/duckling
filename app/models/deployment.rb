class Deployment < ActiveRecord::Base
  belongs_to :activation
  belongs_to :deployed, polymorphic: true
  
  # belongs_to :user, class_name: 'User', foreign_key: 'deployed_id'
  # belongs_to :organization, class_name: 'Organization', foreign_key: 'deployed_id'
end