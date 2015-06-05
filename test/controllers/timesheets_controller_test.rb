require 'test_helper'

class TimesheetsControllerTest < ActionController::TestCase
  
  setup do
    @admin = users(:kyle)
    @user = users(:matt)
    @track = tracks(:placid)
    @circuit = circuits(:worldcup)
    @timesheet = timesheets(:training)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_template 'timesheets/index'
    assert_select "title", "Sledsheet | Timesheets"
    assert_not_nil assigns(:timesheets)
    Timesheet.all.each do |timesheet|
      assert_select 'a[href=?]', timesheet_path(timesheet), text: timesheet.name
    end
  end
  
  test "admin should get new" do
    log_in_as @admin
    get :new
    assert_response :success
    assert_template :new
    assert_select "title", "Sledsheet | New Timesheet"
    assert_not_nil assigns(:timesheet)
  end
  
  test "user should not get new" do
    log_in_as @user
    get :new
    assert_redirected_to root_path
  end
  
  test "should get show" do
    get :show, id: @timesheet
    assert_response :success
    assert_template :show
    assert_select "title", "Sledsheet | #{@timesheet.name}"
    assert_not_nil assigns(:timesheet)
  end
  
  test "admin should get edit" do
    log_in_as @admin
    get :edit, id: @timesheet
    assert_response :success
    assert_template :edit
    assert_select "title", "Sledsheet | Edit #{@timesheet.name}"
    assert_not_nil assigns(:timesheet)
  end
  
  test "user should not get edit" do
    log_in_as @user
    get :edit, id: @timesheet
    assert_redirected_to root_path
  end
  
  test "admin should create timesheet" do
    log_in_as @admin
    assert_difference('Timesheet.count') do
      post :create, timesheet: {track_id: @track.id, circuit_id: @circuit.id, race: false, date: Date.today}
    end
     assert_redirected_to timesheet_path(assigns(:timesheet))
  end
  
  test "user should not create timesheet" do
    log_in_as @user
    assert_no_difference('Timesheet.count') do
      post :create, timesheet: {track_id: @track.id, circuit_id: @circuit.id, race: false, date: Date.today}
    end
  end
  
  test "admin should update timesheet" do
    log_in_as @admin
    patch :update, id: @timesheet, timesheet: {race: true}
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end
  
  test "user should not update timesheet" do
    log_in_as @user
    patch :update, id: @timesheet, timesheet: {race: true}
    assert_redirected_to timesheet_path(assigns(:timesheet))
  end
  
  test "admin should destroy timesheet" do
    log_in_as @admin
    assert_difference('Timesheet.count', -1) do
      delete :destroy, id: @timesheet
    end
    assert_redirected_to timesheets_path
  end
  
  test "user should not destroy timesheet" do
    log_in_as @user
    assert_no_difference('Timesheet.count') do
      delete :destroy, id: @timesheet
    end
    assert_redirected_to root_path
  end

end

