# frozen_string_literal: true

require "test_helper"

class TestDeltaDebug < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::DeltaDebug::VERSION
  end

  def test_array_example
    harness = ->(v) { !([1,7,8] - v).empty? }
    input = (1..8).to_a

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal [1, 7, 8], result
  end

  def test_html_example
    harness = ->(v) { /\A<SELECT.*>\z/i !~ v }
    input = '<SELECT NAME="priority" MULTIPLE SIZE=7>'

    result = DeltaDebug.new(harness).ddmin(input)
    assert_equal "<SELECT>", result
  end
end
