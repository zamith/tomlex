defmodule TomlexTest do
  use ExUnit.Case

  test "integers" do
    parsed_configs = Tomlex.load("""
      pos = 42
      neg = -17
    """)

    assert %{ pos: 42, neg: -17 } == parsed_configs
  end

  test "floats" do
    parsed_configs = Tomlex.load("""
      pi = 3.1415
      neg_point_oh_one = -0.01
    """)

    assert %{ pi: 3.1415, neg_point_oh_one: -0.01 } == parsed_configs
  end

  test "comments" do
    parsed_configs = Tomlex.load("""
      # I am a comment. Hear me roar. Roar.
      key = "value" # Yeah, you can do this.
    """)

    assert %{ key: "value" } == parsed_configs
  end

  test "load from a file" do
    assert %{ key: "value" } == File.read!("test/examples/simple_assignment.toml") |> Tomlex.load
  end
end
