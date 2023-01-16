defmodule Lunar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Dotenv.load()

    children = [
      # Start the Telemetry supervisor
      LunarWeb.Telemetry,
      # Start the database repo:
      {Mongo, Lunar.Repo.generate_child_schema()},
      # Start the PubSub system
      {Phoenix.PubSub, name: Lunar.PubSub},
      # Start the Endpoint (http/https)
      LunarWeb.Endpoint
      # Start a worker by calling: Lunar.Worker.start_link(arg)
      # {Lunar.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lunar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LunarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
