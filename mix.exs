defmodule Tomlex.Mixfile do
  use Mix.Project

  def project do
    [app: :tomlex,
     version: "0.0.6",
     elixir: ">= 1.0.0",
     description: "A TOML parser for elixir",
     package: package(),
     source_url: "https://github.com/zamith/tomlex",
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, "~> 0.1", only: :docs},
      {:ex_doc, "~> 0.6", only: :docs},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp package do
    [
      contributors: ["Zamith"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/zamith/tomlex"}
    ]
  end
end
