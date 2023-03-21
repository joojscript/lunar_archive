defmodule Lunar.Queue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    unless Mix.env() == :prod do
      Dotenv.load()
      Mix.Task.run("loadconfig")
    end

    children = [
      # Starts a worker by calling: Queue.Worker.start_link(arg)
      # {Queue.Worker, arg}
      {Lunar.Queue.AMQPConnectionManager, [System.get_env("RABBIT_MQ_URI")]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lunar.Queue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
