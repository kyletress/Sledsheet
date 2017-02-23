class TeamsController < ApplicationController
  before_action :logged_in_user
  before_action :load_team, except: [:index, :new, :create, :join, :show]

  def index
    @teams = Team.all
  end

  def show
    @team = Team.includes(:memberships).find(params[:id])
  end

  def new
    @team = Team.new
  end

  def edit
    if @team.update_attributes(team_params)
      redirect_to @team, success: "Team updated"
    else
      render 'edit', notice: "Team couldn't be updated"
    end
  end

  def create
    @team = current_user.managed_teams.build(team_params)
    @team.team_code = generate_team_code
    if @team.save
      redirect_to @team, success: "Team has been created"
    else
      render 'new', notice: "Team could not be created"
    end
  end

  def update

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

    def generate_team_code
      SecureRandom.hex(4)
    end
end
