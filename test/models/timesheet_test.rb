require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  def setup
    @timesheet = timesheets(:training)
  end

  test "should be valid" do
    assert @timesheet.valid?
  end

  test "name should be correct" do
    assert @timesheet.name == "Igls World Cup Training"
    @timesheet.track = tracks(:placid)
    @timesheet.circuit = circuits(:olympics)
    @timesheet.race = true
    @timesheet.save
    assert @timesheet.name == "Lake Placid Olympic Winter Games Race 2014-15 Men", "It was named incorrectly"
  end

  test "name should not give error if season does not exist" do
    assert @timesheet.name == "Igls World Cup Training"
    @timesheet.date = Date.new(2030, 10, 30)
    @timesheet.save
    assert @timesheet.name == "Igls World Cup Training 2030-31 Men", "Wrong Season"
  end

  test "track id should be present" do
    @timesheet.track_id = nil
    assert_not @timesheet.valid?
  end

  test "circuit id should be present" do
    @timesheet.circuit_id = nil
    assert_not @timesheet.valid?
  end

  test "date should be present" do
    @timesheet.date = nil
    assert_not @timesheet.valid?
  end

  test "should assign correct season based on date" do
    assert @timesheet.season.name == "2014/2015 Season"
    @timesheet.date = Date.new(2016, 10, 30)
    @timesheet.save
    assert @timesheet.season.name == "2016/2017 Season", "Wrong Season"
  end

  test "should use existing season if available" do
    @timesheet.date = Date.new(2015, 10, 30)
    assert_no_difference 'Season.count' do
      @timesheet.save
    end
  end

  test "should create new season if necessary" do
    @timesheet.date = Date.new(2016, 10, 30)
    assert_difference 'Season.count', 1 do
      @timesheet.save
    end
  end

  test "order should be most recent first" do
    assert_equal timesheets(:latest), Timesheet.first
  end

  test "it gives nice date formatting" do
    assert @timesheet.nice_date == "October 30, 2014"
  end

  test "it gives machine date formatting" do
    assert @timesheet.machine_date == "2014-10-30"
  end

  test "it gives the correct formatting for pdf titles" do
    assert @timesheet.pdf_name == "2014-10-30-igls-world-cup-training"
  end

  test "it should return the correct best run" do
    assert_equal @timesheet.best_run(1), runs(:kyle1), "It returned the wrong best run"
  end

  test "it should return the correct position for a given athlete" do
    assert_equal @timesheet.position_for(athletes(:kyle)), 1
  end

end
