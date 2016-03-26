require 'test_helper'

class EntryTest < ActiveSupport::TestCase

  def setup
    @entry = entries(:kyle)
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "should have an athlete id" do
    @entry.athlete_id = nil
    assert_not @entry.valid?, "saved entry without an athlete id"
    @entry.athlete_id = "Kyle Tress"
    assert_not @entry.valid?, "saved entry with a string for an athlete_id"
  end

  test "should have a timesheet id" do
    @entry.timesheet_id = nil
    assert_not @entry.valid?, "saved entry without a timesheet id"
  end

  test "total time should be the sum of run finish times" do
    @run1 = runs(:kyle1)
    @run2 = runs(:kyle2)
    assert @entry.pdf_total_time == 11113, "Total time wasn't properly calculated"
  end

  test "should return its athlete's name" do
    assert_equal "Kyle Tress", @entry.athlete_name
  end

end
