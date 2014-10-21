# Tomlex

A TOML parser for elixir.

## Getting Started

### Requirements

* Elixir v1.0.0+

### Usage

Add tomlex as a dependency in your `mix.exs` file.

``` elixir
defp deps do
  [{:tomlex, ">= 0.0.0"}]
end
```

After you're done, run `mix deps.get` in your shell top fetch the dependencies.

Tomlex gets a string and parses it into an elixir `Map` using the `load`
function.

``` elixir
defmodule YourApp do
  alias Tomlex

  def your_function do
    parsed_file = File.read!("path/to/file.toml") |> Tomlex.load
  end
end
```

# License

The MIT License (MIT)

Copyright (c) 2014-2015 Luis Zamith Ferreira

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
