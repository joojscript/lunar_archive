defmodule Lunar.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Lunar.Router}
    ]

    opts = [strategy: :one_for_one, name: Lunar.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
