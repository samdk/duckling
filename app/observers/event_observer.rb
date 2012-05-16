class EventObserver < ActiveRecord::Observer
  observe :update, :comment, :invitation, :membership,
    'Mapping::OrganizationSection', 'Mapping::ActivationOrganization'

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
      email = case recipient
        when Email then recipient
        when User  then recipient.primary_email
        else            Email.where(email: recipient.to_s).first_or_create()
      end

      email.notify record, event unless email.nil?
    end
  end
end
