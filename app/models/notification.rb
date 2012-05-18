class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  
  scope :unseen, where(dismissed: false)
  
  def dismiss
    update_attributes dismissed: true, emailed: true
  end

  before_save :set_email_preference
  def set_email_preference
    t = target

    should_email = case t
      when Membership                      then user_id != t.creating_user_id
      when Update, Comment                 then user_id != t.author_id
      when Mapping::OrganizationSection    then true # TODO
      when Mapping::ActivationOrganization then true # TODO
      else true
    end

    self.emailed = !should_email
    
    true
  end
  
  def email
    user.primary_email
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
    hash = {email: user.primary_email_address, target_type: target_type, target_id: target_id}
    t("notification.#{target.class.table_name}.#{event}.#{type}", hash)
  end

end
