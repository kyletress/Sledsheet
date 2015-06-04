require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Timesheets"
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Timesheet"
  end

end

