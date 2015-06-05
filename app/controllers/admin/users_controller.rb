class Admin::UsersController < AdminController

  def index
    @users = User.all
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted."
    redirect_to admin_users_url
  end
  
end