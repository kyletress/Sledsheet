require 'test_helper'

class PointTest < ActiveSupport::TestCase
  def setup
    @point = points(:wc_1_first)
  end

  test "should be valid" do
    assert @point.valid?
  end

end
