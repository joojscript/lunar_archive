defmodule Lunar.Hosts.Service do
  alias Lunar.Registry
  alias Lunar.Hosts.Repository
  alias Lunar.Hosts.Host

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
    case Registry.TemporaryHostIdentifiersManager.retrieve_host_by_random_identifier(
           host_temporary_identifier
         ) do
      {:ok, hostname} ->
        Registry.TemporaryHostIdentifiersManager.cleanup_host_by_random_identifier(
          host_temporary_identifier
        )

        {:ok, hostname}

      _ ->
        {:error, :host_not_found}
    end
  end
end
