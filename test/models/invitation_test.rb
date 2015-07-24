require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  def setup
    @invitation = invitations(:with_sender)
  end

  test "should be valid" do
    assert @invitation.valid?
  end

  test "should create a token" do
    @invite = Invitation.create(sender_id: 1, recipient_email: "kyle@kyle.com")
    assert @invitation.token.present?
  end

  test "email should be present" do
    @invitation.recipient_email = "   "
    assert_not @invitation.valid?
  end

  test "email should not be too long" do
    @invitation.recipient_email = "a" * 244 + "@example.com"
    assert_not @invitation.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @invitation.recipient_email = valid_address
      assert @invitation.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @invitation.recipient_email = invalid_address
      assert_not @invitation.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_invite = @invitation.dup
    duplicate_invite.recipient_email = @invitation.recipient_email.upcase
    @invitation.save
    assert_not duplicate_invite.valid?
  end

  test "should not create an invitation for an existing user" do
    @user = users(:kyle)
    @invite = Invitation.create(sender_id: 1, recipient_email: @user.email)
    assert_not @invite.valid?, "Sent an invitation for #{@user.email}, who is already registered"
  end

end
