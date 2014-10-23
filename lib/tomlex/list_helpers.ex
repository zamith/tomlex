defmodule Tomlex.ListHelpers do
  alias Tomlex.StringHelpers

  def apply_to_nested_lists(value, callback) when is_list(value) do
    value |> Enum.map(&apply_to_nested_lists(&1, callback))
  end

  def apply_to_nested_lists(value, callback) do
    value |> String.strip |> recurse_on_nested_list(callback)
  end

  defp recurse_on_nested_list(value, callback) do
    cond do
      match = Regex.run(~r/^\[(.*?)\],?(.*)/, value) ->
        [_, inner_value, rest] = match
        build_nested_list(inner_value, rest, callback)
      true ->
        callback.(value)
    end
  end

  defp build_nested_list(inner_value, "", callback), do: apply_to_nested_lists(inner_value, callback)
  defp build_nested_list(inner_value, rest, callback), do: [apply_to_nested_lists(inner_value, callback), apply_to_nested_lists(rest, callback)]
end
