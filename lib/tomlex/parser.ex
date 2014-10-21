defmodule Tomlex.Parser do
  alias Tomlex.Line

  def parse(lines) do
    parse(lines, %{})
  end

  defp parse([], result), do: result

  defp parse([%Line.Text{line: line} | rest], result) do
    parse(rest, result)
  end

  defp parse([%Line.Assignment{key: key, value: value} | rest], result) do
    updated_result = case parse_value(value) do
      {:ok, parsed_value} -> Map.put result, String.to_atom(String.strip(key)), parsed_value
      :error -> Map.put result, String.to_atom(String.strip(key)), unquote_string(String.strip(value))
    end
    parse(rest, updated_result)
  end

  defp parse_value(value) do
    parsed_value = String.strip(value) |> Integer.parse
    case parsed_value do
      {int, _} -> {:ok, int}
      :error -> :error
    end
  end

  defp unquote_string(string) do
    String.replace string, "\"", ""
  end
end
