module TifiTasks
  class Invitations
    def perform
      if i = Invitation.where(emailed: false).first
        UserMailer.invite(i).deliver
        i.update_attribute :emailed, true
      end
    end
  end
end
