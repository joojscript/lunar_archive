defmodule Lunar.Broker do
  use Rabbit.Broker

  require Logger

  alias Lunar.Services
  alias Lunar.Helpers

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
  def handle_message(
        message = %Rabbit.Message{meta: %{routing_key: routing_key}, payload: payload}
      ) do
    # Handle message consumption per consumer
    case routing_key do
      "SCAN_RESULT" ->
        handle(:SCAN_RESULT, payload)
        {:ack, message}

      _ ->
        Logger.error("Unknown routing key: #{routing_key}")
        {:nack, message}
    end
  end

  @impl Rabbit.Broker
  def handle_error(message) do
    IO.inspect(message)
    # Handle message errors per consumer
    {:nack, message}
  end

  def send_scan_request(request_payload) do
    parsed_payload =
      request_payload
      |> Poison.encode!()

    Rabbit.Broker.publish(Lunar.Broker, "", "SCAN_REQUEST", parsed_payload)
    Logger.info("Sent scan request: #{inspect(request_payload)}")
  end

  defp handle(:SCAN_RESULT, payload) do
    case payload do
      "" ->
        Logger.error("Invalid payload: #{inspect(payload)}")

      _ ->
        decoded_body =
          Poison.decode!(payload)

        parsed_objects =
          decoded_body
          |> Enum.map(&Helpers.Grpc.Parser.map_to_typed_struct(&1, Services.ScanResult))

        parsed_objects |> Enum.map(&Lunar.Repository.ScanResults.insert_one!(&1))
    end
  end
end
