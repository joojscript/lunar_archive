defmodule Lunar.Scans.Service do
  @scanner_executable Path.expand("../../../../bin/rustscan", __DIR__)
  @scan_result_parse_regexp ~r/(\d+)\/([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)/

  alias Lunar.Repo
  alias Lunar.Scans.Scan

  @spec execute_scan!(Lunar.Host.t()) :: Lunar.Scan.t()
  def execute_scan!(host) do
    scan_result = System.cmd(@scanner_executable, ["-a", host.hostname])

    case scan_result do
      {scan_result, 0} ->
        lines = String.split(scan_result, "\n")

        Enum.map(lines, fn line -> Regex.run(@scan_result_parse_regexp, line) end)
        |> Enum.filter(fn element -> !is_nil(element) end)
        |> Enum.map(fn [_, port, protocol, state, service, reason] ->
          %Scan{
            host_id: host.id,
            results: %{
              port: String.to_integer(port),
              protocol: protocol,
              state: state,
              service: service,
              reason: reason
            }
          }
        end)

      {scan_result, _} ->
        throw("Error while executing scan: #{scan_result}")
    end
  end

  def execute_and_save_scan!(host) do
    scans = execute_scan!(host)

    scans |> Enum.each(&Repo.insert!/1)
  end
end
