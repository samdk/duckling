class Notification < ActiveRecord::Base
  belongs_to :email
  belongs_to :target, polymorphic: true
  
  scope :unseen, where(dismissed: false)
  
  def dismiss
    update_attributes dismissed: true, emailed: true
  end

  def after_save
    puts "NOTIFICATION TO #{user.primary_email_address}: #{to_log}" # TODO: DELETE
  end

  before_save :set_email_preference
  def set_email_preference
    t = target

    should_email = case t
      when Membership                      then email_id != t.creator.primary_email_id
      when Update, Comment                 then email_id != t.author.primary_email_id # TODO
      when Invitation                      then email_id == t.email_id
      when Mapping::OrganizationSection    then true # TODO
      when Mapping::ActivationOrganization then true # TODO
      else true
    end

    self.emailed = !should_email
    
    true
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
    hash = {email: email.email, target_type: target_type, target_id: target_id}
    t("notification.#{target.class.table_name}.#{event}.#{type}", hash)
  end

end
