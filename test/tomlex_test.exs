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

  test "booleans" do
    parsed_configs = Tomlex.load("""
      true = true
      false = false
    """)

    assert %{ true: true, false: false } == parsed_configs
  end

  test "nested tables" do
    parsed_configs = Tomlex.load("""
      [servers.alpha]
       ip = "10.0.0.1"
    """)

    assert %{ servers: %{ alpha: %{ ip: "10.0.0.1" }}} == parsed_configs
  end

  test "empty tables" do
    parsed_configs = Tomlex.load("""
      [servers]
    """)

    assert %{ servers: %{ }} == parsed_configs
  end

  test "nested multi values tables" do
    parsed_configs = Tomlex.load("""
      [servers]
       ip = "10.0.0.1"

       ip2 = "10.0.0.2"
    """)

    assert %{ servers: %{ ip: "10.0.0.1", ip2: "10.0.0.2" }} == parsed_configs
  end

  test "super nested tables" do
    parsed_configs = Tomlex.load("[x.y.z.w]")

    assert %{ x: %{ y: %{ z: %{ w: %{}}}}} == parsed_configs
  end

  test "empty table array" do
    parsed_configs = Tomlex.load("""
      [[products]]
    """)

    assert %{ products: [ %{} ] } == parsed_configs
  end

  test "table arrays" do
    parsed_configs = Tomlex.load("""
      [[products]]
      name = "Hammer"
      sku = 738594937

      [[products]]
    """)

    assert %{ products: [ %{ name: "Hammer", sku: 738594937 }, %{} ] } == parsed_configs
  end

  # test "ultra mega table array" do
  #   parsed_configs = Tomlex.load("""
  #     [[fruit]]
  #       name = "apple"

  #     [[fruit.physical]]
  #       color = "red"
  #       shape = "round"

  #     [[fruit.variety]]
  #       name = "red delicious"

  #     [[fruit.variety]]
  #       name = "granny smith"

  #     [[fruit]]
  #       name = "banana"

  #     [[fruit.variety]]
  #       name = "plantain"
  #   """)

  #   assert %{
  #     fruit: [ %{
  #       name: "apple",
  #       physical: %{
  #         color: "red",
  #         shape: "round"
  #       },
  #       variety: [%{
  #         name: "red delicious"
  #       }, %{
  #         name: "granny smith"
  #       }]
  #     }, %{
  #       name: "banana",
  #       variety: [%{
  #         name: "plantain"
  #       }]
  #     }]} == parsed_configs
  # end

  test "comments" do
    parsed_configs = Tomlex.load("""
      # I am a comment. Hear me roar. Roar.
      key = "value" # Yeah, you can do this.
    """)

    assert %{ key: "value" } == parsed_configs
  end

  test "arrays" do
    parsed_configs = Tomlex.load("""
      a = [ 1, 2, 3.2 ]
      b = [ true, "yellow", "green" ]
      c = [ [ 1, [ 2 ] ], [3, 4, 5], 6 ]
    """)

    assert %{ a: [1,2,3.2], b: [true, "yellow", "green"], c: [[1,[2]],[3,4,5],6] } == parsed_configs
  end

  test "load from a file" do
    assert %{ key: "value" } == File.read!("test/examples/simple_assignment.toml") |> Tomlex.load
  end

  test "putting all together" do
    data = %{
      :title => "TOML Example",
      :owner => %{
        :name => "Tom Preston-Werner",
        :organization => "GitHub",
        :bio => "GitHub Cofounder & CEO\nLikes tater tots and beer."
      },
      :database => %{
        :server => "192.168.1.1",
        :ports => ["8001", "8001", "8002"],
        :connection_max => 5000
      },
      :servers => %{
        :alpha => %{
          :ip => "10.0.0.1",
          :dc => "eqdc10"
        },
        :beta => %{
          :ip=>"10.0.0.2",
          :dc => "eqdc10"
        }
      }
    }
    assert data == File.read!("test/examples/sample.toml") |> Tomlex.load
  end
end
