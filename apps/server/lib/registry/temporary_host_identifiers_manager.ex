defmodule Lunar.Registry.TemporaryHostIdentifiersManager do
  use GenServer

  require Logger

  @global_session_bucket_key :temporary_host_identifiers

  def start_link(init_arg \\ []) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(init_arg \\ []) do
    :ets.new(@global_session_bucket_key, [:set, :public, :named_table])
    Logger.info("TemporaryHostIdentifiersManager initialized")
    {:ok, init_arg}
  end

  @spec insert_temporary_host_identifier(hostname :: String.t()) :: {:ok, String.t()}
  def insert_temporary_host_identifier(hostname) do
    # Schedule the removal of this instance after 1 minute:
    :timer.apply_after(60_000, __MODULE__, :cleanup_host_by_random_identifier, [hostname])

    GenServer.call(__MODULE__, {:insert_temporary_host_identifier, hostname})
  end

  def retrieve_host_by_random_identifier(random_identifier) do
    GenServer.call(__MODULE__, {:retrieve_host_by_random_identifier, random_identifier})
  end

  def cleanup_host_by_random_identifier(random_identifier) do
    GenServer.call(__MODULE__, {:cleanup_host_by_random_identifier, random_identifier})
  end

  def handle_call({:insert_temporary_host_identifier, hostname}, _from, _state) do
    unique_identifier = Ecto.UUID.generate()
    :ets.insert(@global_session_bucket_key, {unique_identifier, hostname})
    {:reply, {:ok, unique_identifier}, unique_identifier}
  end

  def handle_call({:retrieve_host_by_random_identifier, random_identifier}, _from, state) do
    host_lookup_result =
      case :ets.lookup(@global_session_bucket_key, random_identifier) do
        [{^random_identifier, host}] -> {:ok, host}
        [] -> {:error, :host_not_found}
      end

    {:reply, host_lookup_result, state}
  end

  def handle_call({:cleanup_host_by_random_identifier, random_identifier}, _from, state) do
    :ets.delete(@global_session_bucket_key, random_identifier)
    {:reply, :ok, state}
  end
end
