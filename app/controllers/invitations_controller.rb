class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user
    if @invitation.save
      if current_user
        UserMailer.invitation(@invitation).deliver_later
        flash[:success] = "Invitation sent."
        redirect_to timesheets_path
      else
        flash[:success] = "Thanks, we've added you to the waitlist."
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  def update
    @invitation = Invitation.find(params[:id])
    @invitation.sender = current_user
    if @invitation.save
      UserMailer.invitation(@invitation).deliver_later
      flash[:success] = "Invitation sent."
      redirect_to admin_invitations_path
    else
      flash[:success] = "Did not send invite."
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end

end
