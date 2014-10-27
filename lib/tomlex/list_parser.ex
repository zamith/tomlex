defmodule Tomlex.ListParser do
  def parse(list_string) do
    # FIXME: This is a security flaw, remove the eval ASAP
    list_string |> Code.eval_string |> elem(0)
  end
end
