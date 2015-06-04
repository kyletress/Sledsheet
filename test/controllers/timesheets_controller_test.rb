require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  
  setup do
    @admin = users(:kyle)
    @user = users(:matt)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Timesheets"
  end
  
  test "admin should get new" do
    log_in_as @admin
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Timesheet"
  end
  
  test "user should not get new" do
    log_in_as @user
    get :new
    assert_redirected_to root_path
  end

end

