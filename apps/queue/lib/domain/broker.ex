defmodule Lunar.Queue.Broker do
  use Rabbit.Broker

  alias Lunar.Queue.Services
  alias Lunar.Queue.Helpers

  def start_link(opts \\ []) do
    Rabbit.Broker.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Callbacks

  @impl Rabbit.Broker
  # Perform runtime configuration per component
  def init(:connection_pool, opts), do: {:ok, opts}
  def init(:connection, opts), do: {:ok, opts}
  def init(:topology, opts), do: {:ok, opts}
  def init(:producer_pool, opts), do: {:ok, opts}
  def init(:producer, opts), do: {:ok, opts}
  def init(:consumer_supervisor, opts), do: {:ok, opts}
  def init(:consumer, opts), do: {:ok, opts}

  @impl Rabbit.Broker
  def handle_message(message) do
    # Handle message consumption per consumer
    IO.inspect(message.payload)
    {:ack, message}
  end

  @impl Rabbit.Broker
  def handle_error(message) do
    # Handle message errors per consumer
    {:nack, message}
  end

  def send_scan_request(request_payload) do
    decoded_body =
      Helpers.Grpc.Parser.map_to_typed_struct(
        request_payload,
        Services.ScanRequest
      )

    IO.inspect(decoded_body)

    parsed_payload =
      decoded_body
      |> Poison.encode!()

    Rabbit.Broker.publish(Lunar.Queue.Broker, "", "SCAN_REQUEST", parsed_payload)
  end
end
