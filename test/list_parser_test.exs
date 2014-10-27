defmodule ListParserTest do
  use ExUnit.Case
  alias Tomlex.ListParser

  test "empty array" do
    assert ListParser.parse("[]") == []
  end

  test "simple array" do
    assert ListParser.parse("[1, 2]") == [1, 2]
  end

  test "nested array" do
    assert ListParser.parse("[[1, [2]], 3]") == [[1, [2]], 3]
  end
end
