defmodule Tomlex.Parser do
  import Tomlex.StringHelpers
  alias Tomlex.Line

  def parse(lines) do
    parse(lines, %{})
  end

  defp parse([], result), do: result

  defp parse([%Line.Table{keys: keys} | rest], result) do
    inner_values =  parse_all_until(%Line.Table{}, rest, %{})
    build_nested_table(keys, %{}, inner_values)
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

  defp parse_all_until(_, [], parsed_values), do: parsed_values
  defp parse_all_until(terminator_line, [terminator_line | _], parsed_values), do: parsed_values
  defp parse_all_until(terminator_line, [hd | rest], parsed_values) do
    parse_all_until(terminator_line, rest, parse([hd], parsed_values))
  end

  defp build_nested_table([], _, inner_values), do: inner_values
  defp build_nested_table([key | other_keys], nested_map, inner_values) do
    Map.put(nested_map, String.to_atom(key), build_nested_table(other_keys, nested_map, inner_values))
  end
end
