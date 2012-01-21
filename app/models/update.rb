class Update < ActiveRecord::Base
  include Filters
  belongs_to :author, class_name: 'User'
  belongs_to :activation, counter_cache: true
  
  has_many :comments
  has_many :file_uploads

  accepts_nested_attributes_for :file_uploads, allow_destroy: true
  attr_accessor :new_file_uploads
  before_update :add_new_file_uploads
  def add_new_file_uploads
    logger.shout new_file_uploads.inspect
    for upload in Array(new_file_uploads)
      file_uploads.create(upload) # TODO: fix this
    end
    self.new_file_uploads = []
  end
  
  has_and_belongs_to_many :sections
  has_and_belongs_to_many :tags
  
  # Too long titles will break UI, too long body will slow down database.
  # These limits should be sufficient.
  validates :title, presence: true, length: { within: 2..128 }
  validates :body, presence: true, length: { within: 2..100_000 }

  validates_presence_of :author
  
  include AuthorizedModel
  def permit_create?(user, opts = {})
    activation.permit_read? user, opts
  end
  
  def permit_read?(user, *)
    user.deployments.where(activation: self).exists?
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
end
