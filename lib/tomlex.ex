defmodule Tomlex do
  def load(text) do
    String.split(text, "\n", trim: true)
    |> Enum.reduce %{}, fn(line, result) -> parse(line, result) end
  end

  defp parse(line, result) do
    parse_assignment(line, result)
  end

  defp parse_assignment(line, result) do
    [key, value] = String.split(line, "=", trim: true, parts: 2)
    case parse_value(value) do
      {:ok, parsed_value} -> Map.put result, String.to_atom(String.strip(key)), parsed_value
      :error -> :error
    end
  end

  defp parse_value(value) do
    parsed_value = String.strip(value) |> Integer.parse
    case parsed_value do
      {int, _} -> {:ok, int}
      :error -> :error
    end
  end
end
