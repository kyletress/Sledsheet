require 'test_helper'

class TrackTest < ActiveSupport::TestCase

  def setup
    @track = tracks(:placid)
    @igls = tracks(:igls)
  end

  test "should be valid" do
    assert @track.valid?
  end

  test "name should be present" do
    @track.name = "  "
    assert_not @track.valid?
  end

  test "average finish should calculate correctly" do
    assert_equal 5582, @igls.average_finish
  end

  test "start record should calculate correctly" do
    assert_equal 499, @igls.start_record_men
  end

  test "track record should calculate correctly" do
    assert_equal 5455, @igls.track_record_men
  end

end
