defmodule Lunar.Scans.Service do
  import Ecto.Query, only: [from: 2]

  alias Lunar.Repo
  alias Lunar.Scans.Scan

  @scanner_executable Path.expand("../../../../bin/rustscan", __DIR__)
  @scan_result_parse_regexp ~r/(\d+)\/([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)\s+([A-Za-z0-9-_]+)/

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

    Repo.transaction(fn ->
      scans
      |> Enum.each(fn scan ->
        host_id = host.id
        last_scan_port = scan.results.port

        cond do
          is_nil(host_id) or is_nil(last_scan_port) ->
            Repo.insert!(scan)

          true ->
            existing =
              Repo.all(
                from(s in Scan,
                  where: s.host_id == ^host_id and fragment("results->'port'") == ^last_scan_port
                )
              )
              |> List.first()

            if is_nil(existing) do
              Repo.insert!(scan)
            else
              changeset = Ecto.Changeset.change(existing, scan)
              Repo.update!(changeset)
            end
        end
      end)
    end)
  end
end
