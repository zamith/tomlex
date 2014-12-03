defmodule Tomlex.TableArrayBuilder do
  @moduledoc """
  Builds an array of tables structure after it has gone through a parsing step
  """

  @doc """
  Builds an array of tables from a previous result, keys and the values to add.

  ## Examples

      iex> Tomlex.TableArrayBuilder.build(%{x: [%{z: 2}]}, [:x], [], %{y: 1})
      %{ x: [ %{ z: 2 }, %{ y: 1 } ] }
  """
  @spec build(Map.t, List.t, List.t, Map.t) :: Map.t
  def build(result, [], _, _) do
    result
  end
  def build(result, [key | keys], used_keys, inner_values) do
    all_keys = used_keys ++ [key]
    new_result = put_in_new_list(result, all_keys, [inner_values])
    build(new_result, keys, all_keys, inner_values)
  end

  defp put_in_new_list(data, [], value) do
    value
  end
  defp put_in_new_list(data, [key | keys] = all_keys, value) do
    if is_list(data[key]) do
      put_in(data, [key], put_in_new_list(data[key], keys, updated_value(data[key], value)))
    else
      put_in(data, all_keys, value)
    end
  end

  defp updated_value(lhs_data, rhs_data) do
    if map_size(List.first(lhs_data)) == 0 do
      rhs_data
    else
      lhs_data ++ rhs_data
    end
  end
end
