require 'test_helper'

class AthletesControllerTest < ActionController::TestCase

  setup do
    @admin = users(:kyle)
    @user = users(:matt)
    @athlete = athletes(:kyle)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_template 'athletes/index'
    assert_select "title", "Sledsheet | Athletes"
  end

  test "should show athlete" do
    get :show, id: @athlete
    assert_response :success
    assert_template :show
    assert_select "title", "Sledsheet | #{@athlete.first_name} #{@athlete.last_name}"
  end

  test "admin should get new" do
    sign_in @admin
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Athlete"
  end

  test "user should not get new" do
    sign_in @user
    get :new
    assert_redirected_to root_path
  end

  test "admin should get edit" do
    sign_in @admin
    get :edit, id: @athlete
    assert_response :success
    assert_select "title", "Sledsheet | Edit #{@athlete.name}"
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, id: @athlete
    assert_redirected_to root_url
  end

  test "should create athlete" do
    sign_in @admin
    assert_difference('Athlete.count') do
      post :create, athlete: { first_name: 'Morgan', last_name: 'Tracey', country_code: 'US' }
    end
    assert_redirected_to athlete_path(assigns(:athlete))
  end

  test "should update athlete" do
    sign_in @admin
    patch :update, id: @athlete, athlete: { first_name: 'John', last_name: 'Tress', country_code: 'US' }
    assert_redirected_to athlete_path(assigns(:athlete))
  end

end
