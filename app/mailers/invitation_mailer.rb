class InvitationMailer < ApplicationMailer

  def invitation(invitation)
    @invitation = invitation
    mail to: @invitation.recipient_email, subject: "You're invited to Sledsheet"
    invitation.update_attributes(sent_at: Time.now)
  end

  def team_invitation(team_code, invitation)
    @invitation = invitation
    @team_code = team_code
    mail to: @invitation.recipient_email, subject: "You have been invited to join a team on Sledsheet"
    invitation.update_attributes(sent_at: Time.now)
  end
  
end
