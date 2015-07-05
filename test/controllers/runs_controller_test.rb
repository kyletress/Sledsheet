require 'test_helper'

class RunsControllerTest < ActionController::TestCase

  setup do
    @admin = users(:kyle)
    @user = users(:matt)
    @run = runs(:kyle1)
  end

  test "admin should get edit" do
    sign_in @admin
    get :edit, id: @run
    assert_response :success
    assert_template 'runs/edit'
    assert_not_nil assigns(:run)
    assert_select "title", "Sledsheet | Edit Run"
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, id: @run
    assert_redirected_to root_path
  end

end
