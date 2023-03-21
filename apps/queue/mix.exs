defmodule Lunar.Queue.MixProject do
  use Mix.Project

  def project do
    [
      app: :queue,
      version: "0.1.0",
      elixir: "~> 1.15-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Lunar.Queue.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp, "~> 3.2"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]}
    ]
  end
end
