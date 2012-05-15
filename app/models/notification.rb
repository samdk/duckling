class Notification < ActiveRecord::Base
  belongs_to :user
  
  scope :unseen, where(dismissed: false)
  
  def dismiss
    update_attribute :dismissed, true
  end
  
  def after_save
    puts "NOTIFICATION TO #{user.primary_email_address}: #{to_log)}" # TODO: DELETE
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
  
  def to_log
    to_message 'log'
  end
  
  private
  def to_message(type)
    t("notification.#{target_class.table_name}.#{event}.#{type}", user: user, object: reference)
  end
  
end
