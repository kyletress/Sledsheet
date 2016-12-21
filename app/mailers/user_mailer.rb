class UserMailer < ApplicationMailer

  def invitation(invitation)
    @invitation = invitation
    mail to: @invitation.recipient_email, subject: "You're invited to Sledsheet"
    invitation.update_attributes(sent_at: Time.now)
  end

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate your Sledsheet account"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Sledsheet password reset"
  end

  def invitation_to_share(shared_timesheet)
    @shared_timesheet = shared_timesheet
    mail to: @shared_timesheet.shared_email,
         subject: "#{@shared_timesheet.user.name} wants to share the  #{@shared_timesheet.timesheet.name} timesheet with you"
  end

end
