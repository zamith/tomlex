defmodule TomlexTest do
  use ExUnit.Case

  test "integers" do
    parsed_configs = Tomlex.load("""
      pos = 42
      neg = -17
    """)

    assert %{ pos: 42, neg: -17 } == parsed_configs
  end

  test "comments" do
    parsed_configs = Tomlex.load("""
      # I am a comment. Hear me roar. Roar.
      key = "value" # Yeah, you can do this.
    """)

    assert %{ key: "value" } == parsed_configs
  end
end
