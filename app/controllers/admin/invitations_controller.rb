class Admin::InvitationsController < AdminController

  def new
    @invitation = Invitation.new
  end

  def index
    @invitations = Invitation.all
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user
    @invitation.status = "pending"
    if @invitation.save
      UserMailer.invitation(@invitation).deliver_later
      flash[:success] = "Invitation sent."
      redirect_to admin_invitations_path
    else
      flash[:success] = "Thanks, we've added you to the waitlist."
      redirect_to root_path
    end
  end

  # Mail a waitlist invitation
  def update
    @invitation = Invitation.find(params[:id])
    @invitation.sender = current_user
    @invitation.status = "pending"
    if @invitation.save
      UserMailer.invitation(@invitation).deliver_later
      flash[:success] = "Invitation sent."
      redirect_to admin_invitations_path
    else
      flash[:success] = "Did not send invite."
    end
  end

  def destroy
    Invitation.find(params[:id]).destroy
    flash[:success] = "Invitation has been revoked."
    redirect_to admin_invitations_path
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end

end
