require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "", email: "hello@invalid",
                               password: "foo", password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end

  test "valid signup information without an invite" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password", invitation_token: SecureRandom.urlsafe_base64 }
    end
    assert_template 'users/new'
  end

  test "valid signup information with an invite" do
    @invitation = invitations(:with_sender)
    get signup_path(@invitation.token)
    #get "/signup/#{@invitation.token}"
    User.skip_callback(:create, :after, :subscribe_user_to_mailing_list)
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:  "Example User", email: "user@example.com", password: "password", password_confirmation: "password", invitation_token: @invitation.token}
    User.set_callback(:create, :after, :subscribe_user_to_mailing_list)
    end

    assert_template 'users/show'
    assert is_logged_in?
  end
end
