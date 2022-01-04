require "test_helper"

class OffsetTest < BaseTest
  def test_first_value_with_offset
    m1 = OffsetSequencedModel.create
    assert_equal m1.auto_increment, 200_001
    assert_equal m1.string_seq, "101"
    m2 = OffsetSequencedModel.create
    assert_equal m2.auto_increment, 200_002
    assert_equal m2.string_seq, "102"
  end
end
