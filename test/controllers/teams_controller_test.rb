require 'test_helper'

class TeamsControllerTest < ActionController::TestCase

  setup do
    @team = teams(:one)
    @owner = users(:morgan)
    @member = users(:gail)
    @nonmember = users(:matt)
  end

  # logged out users

  test "logged out user should not access team index page" do
    get :index
    assert_redirected_to login_path
  end

  test "logged out user should not access team show page" do
    get :show, params: { id: @team }
    assert_redirected_to login_path
  end

  test "logged out user should not get new team" do
    get :new
    assert_redirected_to login_path
  end

  test "logged out user should not get edit team" do
    get :edit, params: { id: @team }
    assert_redirected_to login_path
  end

  test "logged out user should not be able to delete team" do
    assert_no_difference('Team.count') do
      delete :destroy, params: { id: @team }
    end
    assert_redirected_to login_path
  end

  # logged in team owner

  test "logged in user should get new" do
    log_in_as @owner
    get :new
    assert_response :success
    assert_select "title", "Sledsheet | New Team"
    assert_not_nil assigns(:team)
  end

  test "user should be able to create a team" do
    log_in_as @owner
    assert_difference('Team.count', 1) do
      post :create, params: { team: {name: "test team"} }
    end
    assert assigns(:team).owner == @owner
    assert assigns(:team).team_code.present?
    assert assigns(:team).memberships.includes(@owner)
    assert_redirected_to team_path(assigns(:team))
  end

  test "owner should be able to get their team" do
    log_in_as @owner
    get :show, params: { id: @team }
    assert_response :success
    assert_select "title", "Sledsheet | #{@team.name}"
    assert_not_nil assigns(:team)
  end

  test "owner should be able to edit their team" do
    log_in_as @owner
    get :edit, params: { id: @team }
    assert_response :success
    assert_select "title", "Sledsheet | Edit #{@team.name}"
    assert_not_nil assigns(:team)
  end

  # Haven't allowed for update yet. This is otherwise ready
  test "owner should be able to update their team" do
    log_in_as @owner
    patch :update, params: { id: @team, team: {name: "Update test team"} }
    assert_redirected_to team_path(assigns(:team))
  end

  test "owner should be able to destroy their team" do
    log_in_as @owner
    assert_difference('Team.count', -1) do
      delete :destroy, params: { id: @team }
    end
    assert_redirected_to teams_path
  end

  # logged in team member

  test "members should see the team listed on the index page" do
    log_in_as @member
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Teams"
    assert_not_nil assigns(:memberships)
    @member.teams.each do |team|
      assert_select 'a[href=?]', team_path(team), text: team.name
    end
  end

  test "member should be able to get their team" do
    log_in_as @member
    get :show, params: { id: @team }
    assert_response :success
    assert_select "title", "Sledsheet | #{@team.name}"
    assert_not_nil assigns(:team)
  end

  test "member should not be able to edit their team" do
    log_in_as @member
    get :edit, params: { id: @team }
    assert_redirected_to team_path(@team)
  end

  test "member should not be able to update their team" do
  end

  test "member should not be able to destroy their team" do
    log_in_as @member
    assert_no_difference('Team.count', -1) do
      delete :destroy, params: { id: @team }
    end
    assert_redirected_to team_path(@team)
  end

  # logged in non-team member

  test "nonmembers should not see the team listed on the index page" do
    log_in_as @nonmember
    get :index
    assert_response :success
    assert_select "title", "Sledsheet | Teams"
    assert_not_nil assigns(:memberships)
    assert_select 'a[href=?]', team_path(@team), false, {text: @team.name}
  end

  test "nonmember should not be able to get the team" do
    log_in_as @nonmember
    get :show, params: { id: @team }
    assert_redirected_to teams_path
  end

end
