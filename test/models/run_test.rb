require 'test_helper'

class RunTest < ActiveSupport::TestCase

  def setup
    @run = runs(:kyle1)
  end

  test "should be valid" do
    assert @run.valid?
  end

  test "should have an entry id" do
    @run.entry_id = nil
    assert_not @run.valid?, "saved run without an entry id"
  end

  test "it should correctly calculate intermediates" do
    @run.save
    assert @run.int1 == 611, "Incorrectly calculated int 1"
    assert @run.int2 == 1111, "Incorrectly calculated int 2"
    assert @run.int3 == 1111, "Incorrectly calculated int 3"
    assert @run.int4 == 1111, "Incorrectly calculated int 4"
    assert @run.int5 == 1011, "Incorrectly calculated int 5"
  end

  test "it should correctly calculate the difference from another run" do
    @run2 = runs(:kyle2)
    assert @run2.difference_from(@run) == [1,1,1,1,1,203]
  end

end
