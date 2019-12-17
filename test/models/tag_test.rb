require 'test_helper'

class TagTest < ActiveSupport::TestCase

  test "it works if there is only one tag" do
    tags = Tag.parse('marzipan')
    assert_equal(['marzipan'], tags)
  end

  test "parse works if there are two tags" do
    tags = Tag.parse('peanut-butter jelly')
    assert_equal(%w(peanut-butter jelly),tags)
  end

end