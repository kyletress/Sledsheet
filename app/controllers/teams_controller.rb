class TeamsController < ApplicationController
  before_action :logged_in_user
  before_action :load_team, except: [:index, :new, :create, :join, :show, :edit]
  before_action :admin_or_owner, only: [:edit, :update, :destroy]
  before_action :team_member, only: [:show]

  # team members can view the team page.
  # only admins and owners can edit, update, and destroy teams

  def index
    @memberships = current_user.memberships.includes(team: [:owner])
  end

  def show
    @team = Team.includes(:owner).find(params[:id])
  end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.includes(memberships: [:user]).find(params[:id])
  end

  def create
    @team = current_user.managed_teams.build(team_params)
    @team.generate_team_code
    if @team.save
      @team.memberships.create(user: current_user)
      flash['success'] = "Success! Invite teammates by email or give this code: #{@team.team_code}"
      redirect_to @team
    else
      render 'new', notice: "Team could not be created"
    end
  end

  def update
    if @team.update_attributes(team_params)
      redirect_to @team, success: "Team updated"
    else
      render 'edit', notice: "Team couldn't be updated"
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path
  end

  def join
    @team = Team.find_by(team_code: params[:team_code])
    if @team
      membership = @team.memberships.build(user: current_user)
      membership.save
      Notification.create(recipient: @team.owner, actor: current_user, action: "joined", notifiable: @team)
      redirect_to team_path(@team), success: "You joined the team bruh"
    else
      flash[:notice] = "Sorry, that team doesn't exist"
      redirect_to teams_path
    end
  end

  private

    def team_params
      params.require(:team).permit(:name, :owner_id)
    end

    def load_team
      @team = Team.find(params[:id])
    end

    def team_member
      @team = Team.includes(:owner).find(params[:id])
      @user = current_user
      redirect_to teams_url unless @user == @team.owner || @team.users.include?(@user)
    end

    def admin_or_owner
      @team = Team.includes(:owner).find(params[:id])
      @user = current_user
      redirect_to @team unless @user == @team.owner || @user.admin?
    end

end
