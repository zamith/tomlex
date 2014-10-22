defmodule Tomlex do
  alias Tomlex.Line
  alias Tomlex.Parser

  @doc """
  Parses a string into a map.

  It tokenizes each line (separated by \n) into structs, which are then parsed
  into the map structure.
  """
  @spec load(String.t) :: Map.t
  def load(text) do
    String.split(text, "\n", trim: true)
    |> Enum.map(fn(line) -> Line.tokenize(line) end)
    |> Parser.parse
  end
end
