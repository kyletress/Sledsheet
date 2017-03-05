require 'test_helper'

class CircuitTest < ActiveSupport::TestCase

  def setup
    @circuit = circuits(:worldcup)
    @season = seasons(:season1516)
  end

  test "should be valid" do
    assert @circuit.valid?
  end

  test "name should be present" do
    @circuit.name = "  "
    assert_not @circuit.valid?
  end

  test "current rankings method should return correct ranks" do
    points = Point.circuit_points(@season, @circuit, 0)
    # points = @circuit.current_rankings(0) # men's rankings
    assert_equal 1, points.first.rank
    assert_equal 2, points.second.rank
    assert_equal athletes(:kyle), points.first.athlete
    assert_equal athletes(:matt), points.second.athlete
  end

  test "current rankings method should return correct point totals" do
    # points = @circuit.current_rankings(0) # men's rankings
    points = Point.circuit_points(@season, @circuit, 0)
    assert_equal 450, points.first.total_points
    assert_equal 420, points.second.total_points
  end

  test "ties should be correctly reflected in circuit rankings" do
    # todo
  end
end
