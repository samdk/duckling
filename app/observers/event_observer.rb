class EventObserver < ActiveRecord::Observer
  observe :update, :comment, :invitation, :deployment
  
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
    record.interested_emails.each do |email|
      email.notify record, event
    end
  end
end
