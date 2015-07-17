class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:password, :password_confirmation, :current_password)
    }
  end

  def authenticate_admin
    unless current_user && current_user.admin?
      flash[:notice] = "You don't have permission to do that"
      redirect_to root_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user == @user
  end

  protected

    def authenticate_inviter!
      authenticate_admin
    end

    def after_sign_in_path_for(user)
      user_path(current_user)
    end

end
