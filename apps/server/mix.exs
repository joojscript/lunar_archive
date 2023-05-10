defmodule Lunar.MixProject do
  use Mix.Project

  def project do
    [
      app: :lunar,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ],
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: extra_applications(Mix.env()),
      mod: {Lunar.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.0-pre"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 5.0"},
      {:lettuce, "~> 0.2.0", only: :dev},
      {:ecto_sqlite3, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp extra_applications(:dev), do: [:logger, :lettuce]
  defp extra_applications(:test), do: [:logger]
  defp extra_applications(_), do: [:logger]
end
