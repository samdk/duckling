module TifiTasks
  class Notifications
    def perform
      task = Notification.order('updated_at ASC')
                          .where(emailed: false)
                          .includes(user: [:primary_email])
                          .first

      return if task.nil?

      user = task.email.user
    
      raise "NilUser" if user.nil?

      Tifi.log "Processing #{task.to_log}"

      if user.primary_email.too_recently_emailed?
        task.touch
        return
      end

      notifications = user.notifications
                          .where(emailed: false, dismissed: false)
                          .order('updated_at ASC')

      Notification.transaction do
        notifications.update_all(emailed: true)
        user.primary_email.update_attributes(emailed_at: Time.now, annoyance_level: email.annoyance_level+1)

        begin
          UserMailer.notify(user, notifications).deliver
        rescue
          raise ActiveRecord::RollBack, "Mail delivery failed"
        end

      end
    end
  end
end