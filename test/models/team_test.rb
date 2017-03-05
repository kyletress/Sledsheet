require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = teams(:one)
  end

  test "should be valid" do
    assert @team.valid?
  end

  test "name should be present" do
    @team.name = "     "
    assert_not @team.valid?
  end

  test "name should not be too long" do
    @team.name = "a" * 55
    assert_not @team.valid?
  end

  test "team code should be generated" do
    team_code = @team.team_code
    assert @team.team_code.present?
    @team.generate_team_code
    assert @team.team_code.present?
    assert @team.team_code.length == 8
    assert_not_equal team_code, @team.team_code
  end

end
