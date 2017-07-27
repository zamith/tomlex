defmodule Tomlex.ListParser do
  alias Tomlex.StringHelpers

  @moduledoc """
  Parses a string of lists into a list of properly casted values
  """

  @doc """
  Gets a string of lists and parses it into a list with all the values properly casted.

  ## Examples

      iex> Tomlex.ListParser.parse("[1, 2, 3]")
      [1, 2, 3]

      iex> Tomlex.ListParser.parse("[[1],[2]]")
      [[1],[2]]
  """
  @spec parse(String.t) :: List.t
  def parse(list_string) do
    list_string |> remove_outer_brackets |> String.codepoints |> parse_list([])
  end

  defp remove_outer_brackets(string) do
    String.slice(string, 1..-2)
  end

  defp parse_list([], result), do: result
  defp parse_list([char | rest], result) when char in [",", " ", "\n", "\t"], do: parse_list(rest, result)
  defp parse_list(["]" | rest], result), do: parse_list(rest, result)
  defp parse_list(["[" | rest], result) do
    { inner_rest, updated_rest } = rest |> take_and_drop_while(&(&1 != "]"))
    parse_list(updated_rest, result ++ [parse_list(inner_rest, [])])
  end
  defp parse_list(list, result) do
    { value_list, updated_rest } = list |> take_and_drop_while(&(&1 != ","))
    value = StringHelpers.cast_string(value_list |> Enum.join |> String.trim)
    parse_list(updated_rest, result ++ [value])
  end

  defp take_and_drop_while(list, function) do
    { first, second } = Enum.split_while(list, function)
    { first, second |> Enum.drop(1) }
  end
end
