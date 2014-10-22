defmodule Tomlex.StringHelpers do
  def unquote_string(string) do
    String.replace string, "\"", ""
  end

  def booleanize_string("true"), do: true
  def booleanize_string("false"), do: false
  def booleanize_string(other_string), do: other_string
end
