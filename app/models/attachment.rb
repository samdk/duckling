class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :file, path: ':rails_root/attachments/:attachment/:id/:style/:filename'

  validates_associated  :attachable
  validates_presence_of :attachable, :file_file_name

  attr_accessible :attachable, :file, :attachment_attributes

  def name() file_file_name end
  def size() file_file_size end
  def type() file_content_type end

  def to_s() name end

  include AuthorizedModel
  delegate :permit_create?, :permit_read?, :permit_destroy?, to: :attachable

  def permit_update?() false end
end
