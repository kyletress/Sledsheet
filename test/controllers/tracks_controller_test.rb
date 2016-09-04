require 'test_helper'

class TracksControllerTest < ActionController::TestCase

  setup do
    @track = tracks(:placid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracks)
    Track.all.each do |track|
      assert_select 'a[href=?]', track_path(track), text: track.name
    end
  end

  test "should show track" do
    get :show, params: { id: @track }
    assert_response :success
  end

end
