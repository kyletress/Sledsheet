class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Activate your Sledsheet account"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Sledsheet password reset"
  end

end
