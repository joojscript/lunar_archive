defmodule Lunar.Registry.SessionManager do
  use GenServer

  require Logger

  @global_session_bucket_key :user_sessions

  def start_link(init_arg \\ []) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(init_arg \\ []) do
    :ets.new(@global_session_bucket_key, [:set, :public, :named_table])
    Logger.info("SessionManager initialized")
    {:ok, init_arg}
  end

  def create_session(user) do
    GenServer.call(__MODULE__, {:create_session, user})
  end

  def retrieve_session_from_user_id(session_id) do
    GenServer.call(__MODULE__, {:retrieve_session_from_user_id, session_id})
  end

  def handle_call({:create_session, user}, _from, _state) do
    session_id = Ecto.UUID.generate()
    :ets.insert(@global_session_bucket_key, {session_id, user})
    {:reply, :ok, session_id}
  end

  def handle_call({:retrieve_session_from_user_id, session_id}, _from, state) do
    user_from_session = :ets.lookup(@global_session_bucket_key, session_id)
    {:reply, user_from_session, state}
  end
end
