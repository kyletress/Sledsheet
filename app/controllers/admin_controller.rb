class AdminController < ApplicationController
  before_action :admin_user

  def become
    user = User.find(params[:id])
    sign_in(user, { bypass: true })
    redirect_to root_url, notice: "Impersonating #{user.email}"
  end
end
