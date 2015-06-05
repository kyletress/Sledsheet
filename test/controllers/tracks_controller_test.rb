require 'test_helper'

class TracksControllerTest < ActionController::TestCase
 
  setup do
    @track = tracks(:placid)
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should show track" do
    get :show, id: @track
    assert_response :success
  end

end
