class Admin::InvitationsController < AdminController

  def index
    @invitations = Invitation.waitlist
  end

end
