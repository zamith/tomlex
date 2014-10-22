defmodule Tomlex.Line do
  defmodule Assignment, do: defstruct key: "", value: ""
  defmodule Integer, do: defstruct key: "", value: 0
  defmodule Float, do: defstruct key: "", value: 0
  defmodule Boolean, do: defstruct key: "", value: true
  defmodule Table, do: defstruct keys: []
  defmodule Blank, do: defstruct line: ""

  @table_regex ~r/^\s*\[(.+)\]\s*$/
  @float_regex ~r/^([^=]*)=\s*(-?\d+\.\d+)\s*/
  @integer_regex ~r/^([^=]*)=\s*(-?\d+)\s*/
  @boolean_regex ~r/^([^=]*)=\s*(true|false)\s*/
  @assignment_regex ~r/^([^=]*)=(.*)$/
  @comment_regex ~r/^(.*)#.*$/

  def tokenize(line) do
    line = remove_comments(line)
    cond do
      match = Regex.run(@table_regex, line) ->
        [_, table_names] = match
        %Table{keys: String.split(table_names, ".")}
      match = Regex.run(@float_regex, line) ->
        [_, key, value] = match
        %Float{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@integer_regex, line) ->
        [_, key, value] = match
        %Integer{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@boolean_regex, line) ->
        [_, key, value] = match
        %Boolean{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(@assignment_regex, line) ->
        [_, key, value] = match
        %Assignment{key: String.strip(key), value: String.strip(value)}
      true ->
        %Blank{line: line}
    end
  end

  defp remove_comments(line) do
    case Regex.run(@comment_regex, line) do
      [_, non_comments] -> non_comments
      nil -> line
    end
  end
end
