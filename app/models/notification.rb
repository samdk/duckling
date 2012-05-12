class Notification < ActiveRecord::Base
  belongs_to :user
  
  scope :unseen, where(dismissed: false)
  
  def after_save
    logger.info "Saved #{inspect}"
  end
  
  def reference
    target_class.constantize.find(target_id)
  end
  
  def to_email_string
    to_message 'email'
  end
  
  def to_stream_string
    to_message 'steam'
  end
  
  def to_flash
    to_message 'flash'
  end
  
  private
  def to_message(type)
    t("notification.#{target_class.downcase}.#{event}.#{type}", user: user, object: reference)
  end
  
end
