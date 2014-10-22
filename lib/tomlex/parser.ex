defmodule Tomlex.Parser do
  import Tomlex.StringHelpers
  alias Tomlex.Line

  def parse(lines) do
    parse(lines, %{})
  end

  defp parse([], result), do: result

  defp parse([%Line.Table{keys: keys} | rest], result) do
    { inner_values, updated_rest } =  parse_all_inner_values(rest, %{})
    updated_result = build_nested_table(result, keys, [], inner_values)
    parse(updated_rest, updated_result)
  end

  defp parse([%Line.Float{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), String.to_float(value)
    parse(rest, updated_result)
  end

  defp parse([%Line.Integer{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), String.to_integer(value)
    parse(rest, updated_result)
  end

  defp parse([%Line.Boolean{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), booleanize_string(value)
    parse(rest, updated_result)
  end

  defp parse([%Line.Assignment{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), unquote_string(value)
    parse(rest, updated_result)
  end

  defp parse([%Line.Blank{} | rest], result) do
    parse(rest, result)
  end

  defp parse_all_inner_values([], parsed_values), do: {parsed_values, []}
  defp parse_all_inner_values([%Line.Table{} | _] = rest, parsed_values) do
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
