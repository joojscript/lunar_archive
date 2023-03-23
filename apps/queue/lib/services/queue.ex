defmodule Lunar.Services.Queue do
  def send_scan_request_globally() do
    {:ok, hosts} = Lunar.Repository.Hosts.get_all()

    if is_list(hosts),
      do: hosts,
      else:
        [hosts]
        |> Enum.map(&Lunar.Broker.send_scan_request(&1))
  end
end
