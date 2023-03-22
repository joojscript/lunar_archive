defmodule Lunar.Queue.Services.Queue do
  def send_scan_request_globally() do
    {:ok, hosts} = Lunar.Queue.Repository.Hosts.get_all()

    hosts
    |> Enum.map(&Lunar.Queue.Broker.send_scan_request/1)
  end
end
