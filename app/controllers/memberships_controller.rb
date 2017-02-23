class MembershipsController < ApplicationController
  def new
    @team = Team.find(params[:team_id])
  end

  def create
  end

  def batch_invite
    @team = Team.find(params[:team_id])
    users = params[:invited_participants].split(/,\s*/)
    users.each do |user_email|
      user = check_user_existance(user_email)
      if user
        membership = @team.memberships.build(user: user)
        membership.save
      else
        # email
      end
    end
    redirect_to @team
  end

  private

    def check_user_existance(user_email)
      user = User.find_by(email: user_email)
    end
end
