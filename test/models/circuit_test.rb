require 'test_helper'

class CircuitTest < ActiveSupport::TestCase

  def setup
    @circuit = circuits(:worldcup)
  end

  test "should be valid" do
    assert @circuit.valid?
  end

  test "name should be present" do
    @circuit.name = "  "
    assert_not @circuit.valid?
  end
end
