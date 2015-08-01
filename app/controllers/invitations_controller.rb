class InvitationsController < ApplicationController

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.status = "waitlist"
    if @invitation.save
      flash[:success] = "Thanks, we've added you to the waitlist."
      redirect_to root_path
    else
      flash[:error] = "Sorry, we couldn't add you. Are you already on the wait list?"
      redirect_to root_path
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end

end
