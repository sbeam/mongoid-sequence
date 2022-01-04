require "test_helper"

class OffsetTest < BaseTest
  def test_first_value_with_offset
    m1 = OffsetSequencedModel.create
    assert_equal m1.auto_increment, 5
  end
end
