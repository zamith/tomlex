defmodule Tomlex.Parser do
  alias Tomlex.StringHelpers
  alias Tomlex.LineTypes
  alias Tomlex.TableArrayBuilder

  @moduledoc """
  Parses a list of tokenized TOML lines into the corresponding map.
  """
  @type line_type :: LineTypes

  @doc """
  Parses a list of tokenized TOML lines into the corresponding map.

  ## Examples
      iex> Tomlex.Parser.parse([%Tomlex.LineTypes.Integer{key: "key", value: "23"}])
      %{key: 23}

      iex> Tomlex.Parser.parse([%Tomlex.LineTypes.Table{keys: [:x, :y, :z]}])
      %{x: %{y: %{z: %{}}}}
  """
  @spec parse([line_type]) :: Map.t
  def parse(lines) do
    parse(lines, %{})
  end

  defp parse([], result), do: result

  defp parse([%LineTypes.TableArray{keys: keys} | rest], result) do
    { inner_values, updated_rest } =  parse_all_inner_values(rest, %{})
    updated_result = TableArrayBuilder.build(result, keys, [], inner_values)
    parse(updated_rest, updated_result)
  end

  defp parse([%LineTypes.Table{keys: keys} | rest], result) do
    { inner_values, updated_rest } =  parse_all_inner_values(rest, %{})
    updated_result = build_nested_table(result, keys, [], inner_values)
    parse(updated_rest, updated_result)
  end

  defp parse([%LineTypes.Float{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), String.to_float(value)
    parse(rest, updated_result)
  end

  defp parse([%LineTypes.Integer{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), String.to_integer(value)
    parse(rest, updated_result)
  end

  defp parse([%LineTypes.Boolean{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), StringHelpers.booleanize_string(value)
    parse(rest, updated_result)
  end

  defp parse([%LineTypes.Array{key: key, values: values} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), values
    parse(rest, updated_result)
  end

  defp parse([%LineTypes.Assignment{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), StringHelpers.unquote_string(value)
    parse(rest, updated_result)
  end

  defp parse([%LineTypes.Blank{} | rest], result) do
    parse(rest, result)
  end

  defp parse_all_inner_values([], parsed_values), do: {parsed_values, []}
  defp parse_all_inner_values([%LineTypes.Table{} | _] = rest, parsed_values) do
    {parsed_values, rest}
  end
  defp parse_all_inner_values([%LineTypes.TableArray{} | _] = rest, parsed_values) do
    {parsed_values, rest}
  end
  defp parse_all_inner_values([hd | rest], parsed_values) do
    parse_all_inner_values(rest, parse([hd], parsed_values))
  end

  defp build_nested_table(result, [], keys, inner_values) do
    put_in(result, keys, inner_values)
  end
  defp build_nested_table(result, [key | keys], used_keys, inner_values) do
    all_keys = used_keys ++ [key]
    new_result = put_in_new(result, all_keys, %{})
    build_nested_table(new_result, keys, all_keys, inner_values)
  end

  defp put_in_new(data, keys, value) do
    case get_in(data, keys) do
      nil -> put_in(data, keys, value)
      _ -> data
    end
  end
end
