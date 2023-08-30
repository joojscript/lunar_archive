defmodule Lunar.Application do
  use Application

  alias Lunar.Registry
  alias Lunar.Services

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Lunar.Router},
      Lunar.Repo,
      Registry.SessionManager,
      Registry.OTPBucketManager,
      Registry.TemporaryHostIdentifiersManager,
      Services.Mailer,
      Services.Queue
    ]

    :observer.start()

    opts = [strategy: :one_for_one, name: Lunar.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
