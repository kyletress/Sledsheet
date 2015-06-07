require 'test_helper'

class TrackTest < ActiveSupport::TestCase

  def setup
    @track = tracks(:placid)
  end

  test "should be valid" do
    assert @track.valid?
  end

  test "name should be present" do
    @track.name = "  "
    assert_not @track.valid?
  end
end
