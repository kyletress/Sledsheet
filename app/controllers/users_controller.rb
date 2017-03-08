class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all
  end

  def new
    @token = params[:tc]
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @timesheets = @user.private_timesheets.includes(:track)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if params[:team_code].present?
        join_team(@user, params[:team_code])
        @user.activate
        log_in @user
        flash[:success] = "Welcome to the team"
        redirect_to @user
      else
        @user.send_activation_email
        flash[:info] = "Please check your email to activate your account"
        redirect_to root_url
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id]) # defined in before filter correct_user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :time_zone, :team_code) # might need to add team code
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def join_team(user, team_code)
      @team = Team.find_by(team_code: team_code)
      if @team
        membership = @team.memberships.build(user: user)
        membership.save
        Notification.create(recipient: @team.owner, actor: user, action: "joined", notifiable: @team)
      end
    end

end
