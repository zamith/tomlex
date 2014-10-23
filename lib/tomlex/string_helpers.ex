defmodule Tomlex.StringHelpers do
  def unquote_string(string) do
    string |> Macro.unescape_string |> String.replace "\"", ""
  end

  def booleanize_string("true"), do: true
  def booleanize_string("false"), do: false
  def booleanize_string(other_string), do: other_string

  def cast_string(string) do
    cond do
      match = Regex.run(~r/^(-?\d+\.\d+)$/, string) ->
        [_, float] = match
        String.to_float(float)
      match = Regex.run(~r/^(-?\d+)$/, string) ->
        [_, int] = match
        String.to_integer(int)
      match = Regex.run(~r/^(true|false)$/, string) ->
        [_, bool] = match
        booleanize_string(bool)
      true ->
        unquote_string(string)
    end
  end
end
