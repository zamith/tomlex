defmodule Tomlex.Line do
  defmodule Assignment, do: defstruct key: "", value: ""
  defmodule Integer, do: defstruct key: "", value: 0
  defmodule Text, do: defstruct line: ""

  def tokenize(line) do
    line = remove_comments(line)
    cond do
      match = Regex.run(~r/^([^=]*)=\s*(-?\d+)\s*/, line) ->
        [_, key, value] = match
        %Integer{key: String.strip(key), value: String.strip(value)}
      match = Regex.run(~r/^([^=]*)=(.*)$/, line) ->
        [_, key, value] = match
        %Assignment{key: String.strip(key), value: String.strip(value)}
      true ->
        %Text{line: line}
    end
  end

  defp remove_comments(line) do
    case Regex.run(~r/(.*)#.*$/, line) do
      [_, non_comments] -> non_comments
      nil -> line
    end
  end
end
