defmodule Tomlex do
  def load(text) do
    String.split(text, "\n", trim: true)
    |> Enum.reduce %{}, fn(line, result) -> parse(line, result) end
  end

  defp parse(line, result) do
    [key, value] = String.split(line, "=", trim: true, parts: 2)
    parsed_value = String.strip(value) |> Integer.parse
    case parsed_value do
      {int, _} -> Map.put result, String.to_atom(String.strip(key)), int
      :error -> result
    end
  end
end
