require 'test_helper'

class AthleteTest < ActiveSupport::TestCase
  def setup
    @athlete = Athlete.new(first_name: "Kyle", last_name: "Tress", country_code: "US")
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
  
end
