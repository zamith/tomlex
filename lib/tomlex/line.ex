defmodule Tomlex.Line do
  alias Tomlex.LineTypes
  alias Tomlex.ListParser

  @moduledoc """
  Responsible for the tokenization of line into tomlex valid line type structs.
  """
  @type line_type :: LineTypes

  @table_regex ~r/^\s*\[(.+)\]\s*$/
  @float_regex ~r/^([^=]*)=\s*(-?\d+\.\d+)\s*/
  @integer_regex ~r/^([^=]*)=\s*(-?\d+)\s*/
  @boolean_regex ~r/^([^=]*)=\s*(true|false)\s*/
  @array_regex ~r/^([^=]*)=\s*(\[.*\])\s*$/
  @assignment_regex ~r/^([^=]*)=(.*)$/
  @comment_regex ~r/^(.*)#.*$/

  @doc """
  Tokenizes a string into a line type.

  ## Examples

      iex> Tomlex.Line.tokenize("key = 23")
      %Tomlex.LineTypes.Integer{key: "key", value: "23"}

      iex> Tomlex.Line.tokenize("[x.y.z]")
      %Tomlex.LineTypes.Table{keys: [:x, :y, :z]}
  """
  @spec tokenize(String.t) :: line_type
  def tokenize(line) do
    line = remove_comments(line)
    cond do
      match = Regex.run(@table_regex, line) ->
        [_, table_names] = match
        %LineTypes.Table{keys: parse_keys(table_names)}
      match = Regex.run(@float_regex, line) ->
        [_, key, value] = match
        %LineTypes.Float{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@integer_regex, line) ->
        [_, key, value] = match
        %LineTypes.Integer{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@boolean_regex, line) ->
        [_, key, value] = match
        %LineTypes.Boolean{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@array_regex, line) ->
        [_, key, value] = match
        %LineTypes.Array{key: String.strip(key), values: ListParser.parse(value)}
      match = Regex.run(@assignment_regex, line) ->
        [_, key, value] = match
        %LineTypes.Assignment{key: String.strip(key), value: String.strip(value)}
      true ->
        %LineTypes.Blank{line: line}
    end
  end

  defp remove_comments(line) do
    case Regex.run(@comment_regex, line) do
      [_, non_comments] -> non_comments
      nil -> line
    end
  end

  defp parse_keys(key_string) do
    String.split(key_string, ".")
    |> Enum.map(&String.to_atom(&1))
  end
end
