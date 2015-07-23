class UserMailer < ApplicationMailer

  def invitation(invitation)
    @invitation = invitation
    mail(to: @invitation.recipient_email, subject: "You've been invited to Sledsheet")
    invitation.update_attributes(sent_at: Time.now)
  end

end
