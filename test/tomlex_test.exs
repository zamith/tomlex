defmodule TomlexTest do
  use ExUnit.Case

  test "integers" do
    parsed_configs = Tomlex.load("""
      pos = 42
      neg = -17
    """)

    assert %{ pos: 42, neg: -17 } == parsed_configs
  end
end
