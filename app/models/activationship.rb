class Activationship < ActiveRecord::Base
  belongs_to :activation
  belongs_to :user
end