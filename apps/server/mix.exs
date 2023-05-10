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
      {:lettuce, "~> 0.2.0", only: :dev},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp extra_applications(:dev), do: [:logger, :lettuce]
  defp extra_applications(:test), do: [:logger]
  defp extra_applications(_), do: [:logger]
end
