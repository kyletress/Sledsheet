# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/invitation_mailer/invitation
  def invitation
    invitation = Invitation.all.sample
    InvitationMailer.invitation(invitation)
  end

  # Preview this email at http://localhost:3000/rails/mailers/invitation_mailer/team_invitation
  def team_invitation
    team = Team.all.sample
    invitation = Invitation.all.sample
    InvitationMailer.team_invitation(invitation, team)
  end

end
