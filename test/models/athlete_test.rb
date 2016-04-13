require 'test_helper'

class AthleteTest < ActiveSupport::TestCase
  def setup
    @athlete = athletes(:kyle)
  end

  test "should be valid" do
    assert @athlete.valid?
  end

  test "first name should be present" do
    @athlete.first_name = "     "
    assert_not @athlete.valid?
  end

  test "last name should be present" do
    @athlete.last_name = "     "
    assert_not @athlete.valid?
  end

  test "country code should be present" do
    @athlete.country_code = "     "
    assert_not @athlete.valid?
  end

  test "country_name should return the correct name" do
    assert_equal "United States", @athlete.country_name, "Didn't get United States"
    @german = athletes(:german)
    assert_equal "Germany", @german.country_name, "Didn't get Germany"
  end

  test "timesheet country name should return correct 3 letter abbreviation" do
      assert_equal "USA", @athlete.timesheet_country
      @german = athletes(:german)
      assert_equal "GER", @german.timesheet_country
  end

  test "first name should not be too long" do
    @athlete.first_name = "a" * 21
    assert_not @athlete.valid?
  end

  test "last name should not be too long" do
    @athlete.last_name = "a" * 21
    assert_not @athlete.valid?
  end

  test "name should be first name plus last name" do
    assert_equal "#{@athlete.first_name} #{@athlete.last_name}", @athlete.name, "Name was not properly set"
  end

  test "timesheet name should be properly formatted" do
    assert_equal "TRESS, Kyle", @athlete.timesheet_name
  end

  test "avatar name should be properly formatted" do
    assert_equal "tress-kyle", @athlete.avatar_name
  end

  test "olympian should be in olympics" do
    @olympian = athletes(:olympian)
    assert @olympian.is_olympian?, "Olympian is not in Olympics"
  end

  test "Rookie should not be in the Olympics" do
    @rookie = athletes(:rookie)
    assert_not @rookie.is_olympian?, "Rookie is an Olympian"
  end

  test "find by timesheet name should return the correct athlete" do
    assert_equal Athlete.find_by_timesheet_name("TRESS Kyle").first, @athlete
  end

  test "find by timesheet name should create an athlete if none found" do
    assert_difference 'Athlete.count', 1 do
      @athlete = Athlete.find_or_create_by_timesheet_name("ZZZ Name", "USA", 1)
    end
    assert_equal "Name Zzz", @athlete.name
    assert_equal "female", @athlete.gender
  end

  test "created athlete with multiple last names should format correctly" do
    athlete = Athlete.find_or_create_by_timesheet_name("TRACEY TRESS Morgan", "USA", 1)
    assert_equal "Morgan Tracey Tress", athlete.name
  end

  # eventually should have a test for current and past season points.

  test "points_for method should calculate correct number of season points" do
    season = seasons(:season)
    assert_equal 450, @athlete.points_for(season)
  end

  test "should correctly calculate World Rank" do
    season = seasons(:season1516)
    matt = athletes(:matt)
    assert_equal 1, @athlete.world_rank(season)
    assert_equal 2, matt.world_rank(season)
  end

  test "should correctly calcuate season positions and points" do
    positions = @athlete.season_positions(seasons(:season))
    assert_equal 2, positions.count
    assert_equal 1, positions.first.rank
    assert_equal 225, positions.first.value
  end

end
