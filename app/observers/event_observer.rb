class EventObserver < ActiveRecord::Observer
  observe :update, :comment, :membership, 'Mapping::OrganizationSection', 'Mapping::ActivationOrganization'

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
    record.interested_emails.each do |recipient|
      user = case recipient
        when Email then recipient.user
        when User  then recipient
        else raise "Notifying nothing bizarre"
      end

      user.notify record, event unless user.nil?
    end
  end
end
