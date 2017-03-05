require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase

  setup do
    @admin = users(:kyle)
    @user = users(:matt)
    @user2 = users(:morgan)
    @track = tracks(:placid)
    @circuit = circuits(:worldcup)
    @timesheet = timesheets(:training)
    @personal = timesheets(:personal)
  end

  # Logged out users

  test "logged out user should get see all general timesheets" do
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Timesheets"
    assert_not_nil assigns(:timesheets)
    PublicTimesheet.all.each do |timesheet|
      assert_select 'a[href=?]', timesheet_path(timesheet), text: timesheet.name
    end
  end

  test "logged out user should get show for general timesheet" do
    get :show, params: { id: @timesheet }
    assert_response :success
    assert_select "title", "Sledsheet | #{@timesheet.name}"
    assert_not_nil assigns(:timesheet)
  end

  test "logged out user should not see personal timesheets" do
    get :show, params: { id: @personal }
    assert_redirected_to timesheets_path
  end

  test "logged out user should not get new timesheet" do
    get :new
    assert_redirected_to login_path
  end

  test "logged out user should not get edit timesheet" do
    get :edit, params: { id: @timesheet }
    assert_redirected_to login_path
  end

  test "logged out user should not be able to delete timesheet" do
    assert_no_difference('Timesheet.count') do
      delete :destroy, params: { id: @timesheet }
    end
    assert_redirected_to login_path
  end

  # Logged in user

  test "logged in user should get new" do
    log_in_as @user
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Timesheet"
    assert_not_nil assigns(:timesheet)
  end

  # Correct user

  test "user should be able to create a personal timesheet" do
    log_in_as @user
    assert_difference('Timesheet.count', 1) do
      post :create, params: { timesheet: {track_id: @track.id, circuit_id: @circuit.id, race: false, date: Date.today} }
    end
    assert assigns(:timesheet).user == @user
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "correct user should be able to get their personal timesheet" do
    log_in_as @user
    get :show, params: { id: @personal }
    assert_response :success
    assert_select "title", "Sledsheet | #{@personal.name}"
    assert_not_nil assigns(:timesheet)
  end

  test "correct user should be able to edit their personal timesheet" do
    log_in_as @user
    get :edit, params: { id: @personal }
    assert_response :success
    assert_select "title", "Sledsheet | Edit #{@personal.name}"
    assert_not_nil assigns(:timesheet)
  end

  test "correct user should be able to update their personal timesheet" do
    log_in_as @user
    patch :update, params: { id: @personal, timesheet: {race: true} }
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "correct user should be able to destroy their personal timesheet" do
    log_in_as @user
    assert_difference('Timesheet.count', -1) do
      delete :destroy, params: { id: @personal }
    end
    assert_redirected_to timesheets_path
  end

  test "correct user should be able to copy a timesheet" do
    log_in_as @user
    get :copy, params: { id: @personal }
    assert_response :success
    assert_not_nil assigns(:timesheet)
  end

  # Incorrect user

  test "incorrect user should not see another user's personal timesheet" do
    log_in_as @user2
    get :show, params: { id: @personal }
    assert_redirected_to timesheets_path
  end

  test "incorrect user should not edit another user's personal timesheet" do
    log_in_as @user2
    get :edit, params: { id: @personal }
    assert_redirected_to timesheets_path
  end

  # Admin users

  test "admin should see personal timesheets" do
    log_in_as @admin
    get :show, params: { id: @personal }
    assert_response :success
  end

  test "admin should get edit" do
    log_in_as @admin

    get :edit, params: { id: @timesheet }
    assert_response :success
    assert_select "title", "Sledsheet | Edit #{@timesheet.name}"
    assert_not_nil assigns(:timesheet)

    get :edit, params: { id: @personal }
    assert_response :success
    assert_select "title", "Sledsheet | Edit #{@personal.name}"
    assert_not_nil assigns(:timesheet)
  end

  test "admin should create timesheet" do
    log_in_as @admin
    assert_difference('Timesheet.count') do
      post :create, params: { timesheet: {track_id: @track.id, circuit_id: @circuit.id, race: false, date: Date.today} }
    end
     assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "admin should update timesheet" do
    log_in_as @admin
    patch :update, params: { id: @timesheet, timesheet: {race: true} }
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end

  test "admin should destroy timesheet" do
    log_in_as @admin
    assert_difference('Timesheet.count', -1) do
      delete :destroy, params: { id: @timesheet }
    end
    assert_redirected_to timesheets_path
  end

  # Plain users and general timesheets

  test "regular user should not edit general timesheet" do
    log_in_as @user
    get :edit, params: { id: @timesheet }
    assert_redirected_to timesheets_path
  end

  test "regular user should not update general timesheet" do
    log_in_as @user
    patch :update, params: { id: @timesheet, timesheet: {race: true} }
    assert_redirected_to timesheets_path
  end

  test "regular user should not destroy general timesheet" do
    log_in_as @user
    assert_no_difference('Timesheet.count') do
      delete :destroy, params: { id: @timesheet }
    end
    assert_redirected_to timesheets_path
  end

end
