class InvitationMailer < ApplicationMailer

  def invitation(invitation)
    @invitation = invitation
    mail to: @invitation.recipient_email, subject: "You're invited to Sledsheet"
    invitation.update_attributes(sent_at: Time.now)
  end

  def team_invitation(invitation, team)
    @invitation = invitation
    @team = team
    @team_code = team.team_code
    mail to: @invitation.recipient_email, subject: "#{@team.owner.name} has invited you to join a team on Sledsheet"
    invitation.update_attributes(sent_at: Time.now)
  end

  def existing_user_invitation(user, team)
    @user = user
    @team = team
    @team_code = @team.team_code
    mail to: @user.email, subject: "#{@team.owner.name} has added you to a team on Sledsheet"
  end

end
