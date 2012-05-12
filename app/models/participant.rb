class Participant < ActiveRecord::Base
  belongs_to :update
  belongs_to :section
end