defmodule Lunar.Scans.Worker do
  use Oban.Worker,
    queue: :scans,
    priority: 1,
    max_attempts: 10

  import Ecto.Query, only: [from: 2]

  alias Lunar.Hosts.Host
  alias Lunar.Scans.Service
  alias Lunar.Repo

  def new, do: new(%{})

  @impl Oban.Worker
  def perform(%Oban.Job{args: _args}) do
    # Create a query
    query =
      from(host in Host,
        where: not is_nil(host.verified_at),
        select: host
      )

    all_active_hosts = Repo.all(query)

    all_active_hosts |> Enum.each(&Service.execute_and_save_scan!/1)

    {:ok, :done}
  end
end
