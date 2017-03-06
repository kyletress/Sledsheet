require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase

  setup do
    @team = teams(:one)
    @owner = users(:morgan)
    @member = users(:gail)
    @nonmember = users(:matt)
    @membership = memberships(:gail_team_one)
  end

  # owners

  test "owner can see all memberships" do
    log_in_as @owner
    get :index, params: { team_id: @team.id }
    assert_response :success
    @team.memberships.each do |membership|
      assert_select 'td', text: membership.user.name
    end
  end

  test "owner can visit the invite new members page" do
    log_in_as @owner
    get :new, params: { team_id: @team.id }
    assert_response :success
    assert_select 'form'
  end

  test "owner can invite registered users to join the team" do
    log_in_as @owner
    assert_difference('Membership.count', 2) do
      post :batch_invite, params: { team_id: @team.id, invited_participants: 'bobnardoni@gmail.com, matt@mattantoine.com'}
    end
    assert_redirected_to team_path(@team)
  end

  test "existing member cannot be added twice" do
    log_in_as @owner
    assert_no_difference('Membership.count') do
      post :batch_invite, params: { team_id: @team.id, invited_participants: 'kyle@kyletress.com'}
    end
  end

  test "non-registered user recieves an email invitation" do
    # not yet implemented
  end

  test "owner can edit a membership" do
    log_in_as @owner
    get :edit, params: { team_id: @team.id, id: @membership }
    assert_response :success
    assert_select 'h2', text: 'Edit Membership'
  end

  test "owner can update a membership" do
    # nothing to update yet.
  end

  test "owner can destroy a membership" do
    log_in_as @owner
    assert_difference('Membership.count', -1) do
      delete :destroy, params: { team_id: @team.id, id: @membership }
    end
    assert_redirected_to teams_path
  end

  # Members

  test "member can see all memberships" do
    log_in_as @member
    get :index, params: { team_id: @team.id }
    assert_response :success
    @team.memberships.each do |membership|
      assert_select 'td', text: membership.user.name
    end
  end

  test "member can edit their membership" do
    log_in_as @member
    get :edit, params: { team_id: @team.id, id: @membership }
    assert_response :success
    assert_select 'h2', text: 'Edit Membership'
  end

  test "member can update their membership" do
    # nothing to do yet
  end

  test "member cannot see form to invite new members" do
    log_in_as @member
    get :new, params: { team_id: @team.id }
    assert_redirected_to team_path(@team)
  end

  test "member cannot invite new members" do
    log_in_as @member
    assert_no_difference('Membership.count') do
      post :batch_invite, params: { team_id: @team.id, invited_participants: 'bobnardoni@gmail.com'}
    end
  end

  # Non-members

  test "nonmembers cannot see memberships" do
    log_in_as @nonmember
    get :index, params: { team_id: @team.id }
    assert_redirected_to teams_path
  end

  test "nonmembers cannot see form to invite new members" do
    log_in_as @nonmember
    get :new, params: { team_id: @team.id }
    assert_redirected_to teams_path
  end

  test "nonmembers cannot invite new members to a team" do
    log_in_as @nonmember
    assert_no_difference('Membership.count') do
      post :batch_invite, params: { team_id: @team.id, invited_participants: 'bobnardoni@gmail.com'}
    end
  end

  # logged out users

  test "logged out user cannot invite new members" do
  end

  # inviting users

  test "non-registered user is sent an email to register" do
  end

end
