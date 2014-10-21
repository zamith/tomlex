defmodule Tomlex.Line do
  defmodule Assignment, do: defstruct key: "", value: ""
  defmodule Text, do: defstruct line: ""

  def tokenize(line) do
    line = remove_comments(line)
    cond do
      line =~ ~r/^.*=.*$/x ->
        [key, value] = String.split(line, "=", trim: true, parts: 2)
        %Assignment{key: key, value: value}
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
