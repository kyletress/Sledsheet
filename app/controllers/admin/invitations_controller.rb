class Admin::InvitationsController < AdminController

  def index
    @invitations = Invitation.waitlist
    @pending = Invitation.pending
    @claimed = Invitation.claimed
  end

  def destroy
    Invitation.find(params[:id]).destroy
    flash[:success] = "Invitation has been revoked."
    redirect_to admin_invitations_path
  end

end
