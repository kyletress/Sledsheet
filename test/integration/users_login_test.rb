require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:kyle)
  end

  test "login with invalid information" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    post user_session_path, session: { email: "", password: "" }
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    post user_session_path, session: { email: @user.email, password: 'password' }
    #assert_redirected_to @user
    assert_template 'user/show'
  end

end
