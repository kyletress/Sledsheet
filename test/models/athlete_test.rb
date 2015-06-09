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

  test "first name should not be too long" do
    @athlete.first_name = "a" * 21
    assert_not @athlete.valid?
  end

  test "last name should not be too long" do
    @athlete.last_name = "a" * 21
    assert_not @athlete.valid?
  end

  test "name should be first name plus last name" do
    assert @athlete.name == "#{@athlete.first_name} #{@athlete.last_name}"
  end

  test "olympian should be in olympics" do
    @olympian = athletes(:olympian)
    assert @olympian.is_olympian?, "Olympian is not in Olympics"
  end

  test "Rookie should not be in the Olympics" do
    @rookie = athletes(:rookie)
    assert_not @rookie.is_olympian?, "Rookie is an Olympian"
  end

end
