defmodule Lunar.Services.Scan do
  alias Lunar.Services

  defp global_regex,
    do: ~r"(\d+)\/([A-Za-z\-]+)\s+(open|closed|unknown)\s+([A-Za-z\-]+)\s+([A-Za-z\-]+)"

  @spec perform_scan(Services.ScanRequest.t()) ::
          {:ok, list(Services.ScanResult.t())} | {:error, String.t()}
  def perform_scan(scan_request) do
    case System.shell("rustscan -a #{scan_request["hostname"]} -r 1-65535 -b 1000 -t 1000") do
      {result, 1} ->
        {:error, result}

      {result, 0} ->
        parsed_result =
          Regex.scan(global_regex(), result)
          |> Enum.map(&Enum.slice(&1, 1..9))
          |> Enum.map(fn [port, protocol, status, service, reason] ->
            %Services.ScanResult{
              hostname: scan_request[:hostname],
              port: port,
              protocol: protocol,
              status: status,
              service: service,
              signal: reason
            }
          end)

        {:ok, parsed_result}
    end
  end
end
