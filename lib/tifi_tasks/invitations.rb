module TifiTasks
  class Invitations
    def perform
      if i = Invitation.where(emailed: false).first
        UserMailer.invite(i).deliver
      end
    end
  end
end
