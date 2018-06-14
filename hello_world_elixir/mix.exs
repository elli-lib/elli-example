defmodule HelloWorld.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_world_elixir,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HelloWorld.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elli, "~> 2.1"},
      {:httpoison, "~> 1.0", only: [:test]}
    ]
  end
end
