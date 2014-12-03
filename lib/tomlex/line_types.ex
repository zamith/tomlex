defmodule Tomlex.LineTypes do
  @moduledoc """
  Defines the structs for all the supported types in tomlex.
  """

  defmodule Assignment do
    @moduledoc false
    defstruct key: "", value: ""
  end
  defmodule Integer do
    @moduledoc false
    defstruct key: "", value: 0
  end
  defmodule Float do
    @moduledoc false
    defstruct key: "", value: 0
  end
  defmodule Boolean do
    @moduledoc false
    defstruct key: "", value: true
  end
  defmodule Array do
    @moduledoc false
    defstruct key: "", values: []
  end
  defmodule Table do
    @moduledoc false
    defstruct keys: []
  end
  defmodule TableArray do
    @moduledoc false
    defstruct keys: []
  end
  defmodule Blank do
    @moduledoc false
    defstruct line: ""
  end
end
