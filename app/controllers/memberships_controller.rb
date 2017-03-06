class MembershipsController < ApplicationController
  before_action :logged_in_user
  before_action :team_member, only: [:index, :new]
  before_action :team_owner, only: [:new, :batch_invite]

  def index
    @team = Team.includes(memberships:[:user]).find(params[:team_id])
    @memberships = @team.memberships
  end

  def new
    @team = Team.find(params[:team_id])
  end

  def edit
    @team = Team.find(params[:team_id])
    @membership = Membership.find(params[:id])
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
        # send an email invitation.
      end
    end
    redirect_to @team
  end

  def destroy
    @team = Team.find(params[:team_id])
    @membership = Membership.find(params[:id])
    unless @membership.user == @team.owner
      @membership.destroy
      # Notifiy the team owner
      redirect_to teams_path, notice: "you are no longer a member of #{@team.name}"
    end
  end

  def leave
    # want to differentiate between administrative revoking of membership and willingly leaving.
  end

  private

    def check_user_existance(user_email)
      user = User.find_by(email: user_email)
    end

    def team_owner
      @team = Team.find(params[:team_id])
      redirect_to team_path(@team) unless current_user == @team.owner
    end

    def team_member
      @team = Team.find(params[:team_id])
      redirect_to teams_path unless @team.users.include?(current_user)
    end
end
