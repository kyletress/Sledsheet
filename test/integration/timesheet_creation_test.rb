require 'test_helper'

class TimesheetCreationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:kyle)
    @matt = users(:matt)
  end

  test "admin can create a general timesheet" do
    log_in_as(@user)
    assert is_logged_in?
    get new_timesheet_path
    assert_template 'timesheets/new'
    assert_difference 'Timesheet.count', 1 do
      post timesheets_path, timesheet: { nickname:  "Example Timesheet", track_id: tracks(:placid).id, circuit_id: circuits(:worldcup).id, date: Date.new(2016, 10, 30), race: false, season_id: seasons(:season1516).id, gender: "men", visibility: "general", user_id: @user.id }
    end
    timesheet = assigns(:timesheet)
    assert timesheet.general?
    assert_response :redirect
    assert_redirected_to timesheet_path(timesheet)
    follow_redirect!
    assert_response :success
    assert_select "h2", "Lake Placid World Cup Training 2016-17 Men"
    # ensure the timesheet is public
    get timesheets_path
    assert_template 'timesheets/index'
    timesheets = assigns(:timesheets)
    assert_includes(timesheets, timesheet)
  end

  test "user can create a personal timesheet" do
    log_in_as(@matt)
    assert is_logged_in?
    get new_timesheet_path
    assert_template 'timesheets/new'
    assert_difference '@matt.timesheets.count', 1 do
      post timesheets_path, timesheet: { nickname:  "Example Timesheet", track_id: tracks(:placid).id, circuit_id: circuits(:worldcup).id, date: Date.new(2016, 10, 30), race: false, season_id: seasons(:season1516).id, gender: "men", user_id: @matt.id }
    end
    timesheet = assigns(:timesheet)
    assert timesheet.personal?
    assert_redirected_to timesheet_path(timesheet)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "h2", "Lake Placid World Cup Training 2016-17 Men"
    assert_select "span.badge", "private"
    # check the timesheet isn't public
    get timesheets_path
    assert_template 'timesheets/index'
    timesheets = assigns(:timesheets)
    refute_includes(timesheets, timesheet)
  end

end
