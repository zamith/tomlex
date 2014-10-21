defmodule Tomlex.Parser do
  alias Tomlex.Line

  def parse(lines) do
    parse(lines, %{})
  end

  defp parse([], result), do: result

  defp parse([%Line.Text{line: line} | rest], result) do
    parse(rest, result)
  end

  defp parse([%Line.Integer{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), String.to_integer(value)
    parse(rest, updated_result)
  end

  defp parse([%Line.Assignment{key: key, value: value} | rest], result) do
    updated_result = Map.put result, String.to_atom(key), unquote_string(value)
    parse(rest, updated_result)
  end

  defp unquote_string(string) do
    String.replace string, "\"", ""
  end
end
