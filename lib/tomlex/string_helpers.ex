defmodule Tomlex.StringHelpers do
  @moduledoc """
  A set of conveniencies to use with strings.
  """
  @type valid_type :: Integer.t | Float.t | boolean | String.t

  @doc """
  Removes quotes and escaped characters from a string.

  ## Examples
      iex> Tomlex.StringHelpers.unquote_string("\\"value\\"\\\\n23")
      "value\\n23"
  """
  @spec unquote_string(String.t) :: String.t
  def unquote_string(string) do
    string |> Macro.unescape_string |> String.replace("\"", "")
  end

  @doc """
  Casts the strings `"true"` and `"false"` to their boolean counterparts.
  Returns the string unchanged otherwise.

  ## Examples
      iex> Tomlex.StringHelpers.booleanize_string("true")
      true

      iex> Tomlex.StringHelpers.booleanize_string("not boolean")
      "not boolean"
  """
  @spec booleanize_string(String.t) :: boolean | String.t
  def booleanize_string("true"), do: true
  def booleanize_string("false"), do: false
  def booleanize_string(other_string), do: other_string

  @doc """
  Casts a string to the more appropriate elixir type. If the string cannot be
  casted to any of the valid types for tomlex, it will return the string
  unchanged.

  ## Examples
      iex> Tomlex.StringHelpers.cast_string("123")
      123

      iex> Tomlex.StringHelpers.cast_string("123.4")
      123.4

      iex> Tomlex.StringHelpers.cast_string("false")
      false

      iex> Tomlex.StringHelpers.cast_string("random string")
      "random string"
  """
  @spec cast_string(String.t) :: valid_type
  def cast_string(string) do
    case Integer.parse(string) do
      {int, ""} -> int
      {_, _} -> String.to_float(string)
      :error -> string |> unquote_string |> booleanize_string
    end
  end
end
