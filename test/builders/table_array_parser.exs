defmodule TableArrayBuilderTest do
  use ExUnit.Case
  alias Tomlex.TableArrayBuilder

  test "empty table array" do
    assert TableArrayBuilder.build(%{}, [:x], [], %{}) == %{ x: [ %{} ] }
  end

  test "adding values to an empty list" do
    assert TableArrayBuilder.build(%{}, [:x], [], %{y: 1}) == %{ x: [ %{ y: 1 } ] }
  end

  test "values with more than one key" do
    assert TableArrayBuilder.build(%{}, [:x, :y], [], %{z: 1}) == %{ x: [ %{ y: [ %{ z: 1 } ] } ] }
  end

  test "adding an empty value to a list with previous values" do
    assert TableArrayBuilder.build(
      %{x: [%{z: 2}]},
      [:x],
      [],
      %{}
    ) == %{ x: [ %{ z: 2 }, %{} ] }
  end

  test "adding values to a list with previous values" do
    assert TableArrayBuilder.build(
      %{x: [%{z: 2}]},
      [:x],
      [],
      %{y: 1}
    ) == %{ x: [ %{ z: 2 }, %{ y: 1 } ] }
  end
end
