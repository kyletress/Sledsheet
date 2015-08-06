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

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end

end
