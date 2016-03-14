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
    # not yet implemented
  end

  # test "Athlete should have race points" do
  #   assert_equal 2, @athlete.points.count
  # end

end
