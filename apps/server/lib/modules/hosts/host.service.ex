defmodule Lunar.Hosts.Service do
  alias Lunar.Registry
  alias Registry.TemporaryHostIdentifiersManager, as: HostTmpManager
  alias Lunar.Hosts

  alias Hosts.Repository
  alias Hosts.Host

  @spec create_host(Host.t()) :: {:ok, Host.t()} | {:error, Ecto.Changeset.t()}
  def create_host(host) do
    case Repository.create_one(host) do
      {:ok, host} ->
        Registry.TemporaryHostIdentifiersManager.insert_temporary_host_identifier(host.hostname)
        {:ok, host}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @spec verify_host_attempt(String.t()) ::
          {:ok, hostname :: String.t()} | {:error, :host_not_found}
  def verify_host_attempt(host_temporary_identifier) do
    case HostTmpManager.retrieve_host_by_random_identifier(host_temporary_identifier) do
      {:ok, hostname} ->
        cleanup_tmp(host_temporary_identifier)
        update_host(hostname)

      _ ->
        {:error, :host_not_found}
    end
  end

  defp cleanup_tmp(host_temporary_identifier),
    do: HostTmpManager.cleanup_host_by_random_identifier(host_temporary_identifier)

  defp update_host(hostname) do
    case Repository.find_one_by(:hostname, hostname) do
      {:error, :host_not_found} ->
        {:error, :host_not_found}

      {:ok, host} ->
        case Repository.update_one(host.id, %{verified_at: DateTime.utc_now()}) do
          {:ok, host} ->
            {:ok, host.hostname}

          {:error, _} ->
            {:error, :host_not_found}
        end
    end
  end
end
