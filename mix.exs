defmodule FourcastersApiClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :fourcasters_api_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FourcastersApiClient.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:poison, "~> 4.0"},
      {:gen_stage, "~> 1.0"},
      {:dotenv, "~> 2.0"}
    ]
  end
end
