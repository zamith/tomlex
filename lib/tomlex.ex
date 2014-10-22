defmodule Tomlex do
  alias Tomlex.Line
  alias Tomlex.Parser

  def load(text) do
    String.split(text, "\n")
    |> Enum.map(fn(line) -> Line.tokenize(line) end)
    |> Parser.parse
  end
end
