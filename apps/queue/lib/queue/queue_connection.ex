defmodule Lunar.Queue.AMQPConnectionManager do
  use GenServer
  use AMQP

  require Logger

  @spec start_link(keyword()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  @spec init(binary | keyword) :: no_return()
  def(init(opts)) do
    {:ok, connection} = AMQP.Connection.open(opts |> List.first())
    {:ok, channel} = AMQP.Channel.open(connection)

    Logger.info("Declaring Queues...")
    channel |> declare_queues()

    Logger.info(" [*] Waiting for messages. To exit press CTRL+C, CTRL+C")
    listen()
  end

  @doc """
    Handle messages from the comming from the queue:
  """
  @impl true
  def handle_info({:basic_deliver, args}, state) do
    IO.inspect(args)
    {:noreply, state}
  end

  defp declare_queues(channel) do
    AMQP.Queue.declare(channel, "SCAN_RESULT", durable: true)
    AMQP.Basic.consume(channel, "SCAN_RESULT", nil, no_ack: true)
  end

  defp listen() do
    receive do
      {:basic_deliver, payload, _meta} ->
        Logger.info(" [x] Received #{payload}")
        listen()

      _ ->
        listen()
    end
  end
end
