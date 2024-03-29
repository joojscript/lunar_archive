defmodule Lunar.MixProject do
  use Mix.Project

  def project do
    [
      app: :lunar_core,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Lunar.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:surreal_ex, "~> 0.2.0"},
      {:protobuf, "~> 0.10.0"},
      {:google_protos, "~> 0.1"},
      {:sched_ex, "~> 1.0"},
      {:poison, "~> 5.0"},
      {:rabbit, "~> 0.19"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      "proto.compile": &compile_protos/1
    ]
  end

  defp compile_protos(_args) do
    System.shell(
      "protoc --elixir_out=plugins=grpc:lib/generated --elixir_opt=package_prefix=Lunar --elixir_opt=transform_module=Lunar.Helpers.Grpc.Parser --elixir_opt=include_docs=true --proto_path=../prototype ../prototype/**/*.proto"
    )
  end
end
