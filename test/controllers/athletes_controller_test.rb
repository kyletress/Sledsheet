require 'test_helper'

class AthletesControllerTest < ActionController::TestCase
  
  setup do
    @athlete = athletes(:kyle)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Athletes"
  end
  
  test "should show athlete" do
    get :show, id: @athlete
    assert_response :success
    assert_select "title", "Sledsheet | #{@athlete.first_name} #{@athlete.last_name}"
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Athlete"
  end


end
