require 'test_helper'

class RunsControllerTest < ActionController::TestCase

  setup do
    @admin = users(:kyle)
    @user = users(:matt)
    @run = runs(:kyle1)
  end

  test "admin should get edit for public timesheet" do
    log_in_as @admin
    get :edit, params: { id: @run }
    assert_response :success
    assert_not_nil assigns(:run)
    assert_select "title", "Sledsheet | Edit Run"
  end

  test "non-admin user should not get edit for public timesheet" do
    log_in_as @user
    get :edit, params: { id: @run }
    assert_redirected_to root_path
  end

end
