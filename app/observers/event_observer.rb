class EventObserver < ActiveRecord::Observer
  observe :user, :update, :comment, :invitation, :deployment, 'Section::Mapping'
  
  def after_create(record)
    notify_all record, 'create'
  end
  def after_update(record)
    notify_all record, 'update'
  end
  def after_destroy(record)
    notify_all record, 'destroy'
  end
  
  private
  def notify_all(record, event)
    Array(record.interested_emails).each do |recipient|
      email = case recipient
        when Email then recipient
        when User  then recipient.primary_email
        else            Email.find_or_create_by_email(recipient.to_s)
      end
      email.notify record, event
    end
  end
end
