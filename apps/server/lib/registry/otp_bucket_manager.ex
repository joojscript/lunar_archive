defmodule Lunar.Registry.OTPBucketManager do
  use GenServer

  require Logger

  @global_session_bucket_key :otp_codes

  def start_link(init_arg \\ []) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(init_arg \\ []) do
    :ets.new(@global_session_bucket_key, [:set, :public, :named_table])
    Logger.info("OTPBucketManager initialized")
    {:ok, init_arg}
  end

  @spec add_code(String.t(), String.t()) :: :ok
  def add_code(user_id, otp_code) do
    GenServer.call(__MODULE__, {:add_code, user_id, otp_code})
  end

  @spec get_code(String.t()) :: String.t()
  def get_code(user_id) do
    GenServer.call(__MODULE__, {:get_code, user_id})
  end

  @spec delete_code(String.t()) :: :ok
  def delete_code(user_id) do
    GenServer.call(__MODULE__, {:delete_code, user_id})
  end

  def handle_call({:add_code, user_id, otp_code}, _from, state) do
    :ets.insert(@global_session_bucket_key, {user_id, otp_code})
    {:reply, :ok, state}
  end

  def handle_call({:get_code, user_id}, _from, state) do
    otp_code = :ets.lookup(@global_session_bucket_key, user_id)
    {:reply, otp_code, state}
  end

  def handle_call({:delete_code, user_id}, _from, state) do
    :ets.delete(@global_session_bucket_key, user_id)
    {:reply, :ok, state}
  end
end
