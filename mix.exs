defmodule PipeTo.Mixfile do
  use Mix.Project

  def project do
    [app: :pipe_to,
     version: "0.1.2",
     elixir: "~> 1.3",
     name: "PipeTo",
     source_url: "https://github.com/taiansu/pipe_to",
     homepage_url: "https://taiansu.github.io/pipe_to",
     description: description(),
     package: package(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls]]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    PipeTo operator `~>` is the enhanced pipe operator which can specify the target position.
    """
  end

  defp package do
    [ files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Tai An Su"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub": "https://github.com/taiansu/pipe_to",
               "Docs": "https://taiansu.github.io/pipe_to"}]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.13", only: :dev},
      {:excoveralls, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
