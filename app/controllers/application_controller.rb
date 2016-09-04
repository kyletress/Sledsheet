class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  around_action :set_user_time_zone, if: :current_user

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    private

    def set_user_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block)
    end
end
