require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  setup do
    @admin = users(:kyle)
    @user = users(:matt)
  end

  # test "admin should get new" do
  #   log_in_as @admin
  #   get :new
  #   assert_response :success
  #   assert_select "title", "Sledsheet | New Invitation"
  # end

  # test "user should not get new" do
  #   log_in_as @user
  #   get :new
  #   assert_redirected_to root_path
  # end

  # test "admin should create invitation" do
  #   log_in_as @admin
  #   assert_difference('Invitation.count') do
  #     post :create, invitation: { sender_id: @admin.id, recipient_email: 'kyletress@gmail.com' }
  #   end
  #   assert_redirected_to admin_invitations_path
  # end

end
