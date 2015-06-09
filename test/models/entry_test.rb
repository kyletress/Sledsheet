require 'test_helper'

class EntryTest < ActiveSupport::TestCase

  def setup
    @entry = entries(:one)
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "should have an athlete id" do
    @entry.athlete_id = nil
    assert_not @entry.valid?, "saved entry without an athlete id"
  end

  test "should have a timesheet id" do
    @entry.timesheet_id = nil
    assert_not @entry.valid?, "saved entry without a timesheet id"
  end

  test "total time should be the sum of run finish times" do
    @run1 = runs(:one)
    @run2 = runs(:two)
    assert @entry.total_time == 11111, "Total time wasn't properly calculated"
  end

end
