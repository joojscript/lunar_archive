defmodule Lunar.Application do
  use Application

  @impl true
  def start(_type, _args) do
    unless Mix.env() == :prod do
      Dotenv.load()
      Mix.Task.run("loadconfig")
    end

    children = children()

    opts = [strategy: :one_for_one, name: Lunar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children do
    unless Mix.env() == :test,
      do: [
        %{
          id: "SCAN_REQUESTS_CRON",
          start: {
            SchedEx,
            :run_every,
            # Every minute
            [Lunar.Services.Queue, :send_scan_request_globally, [], "*/1 * * * *"]
          }
        },
        {Lunar.Broker,
         [
           connection: [uri: System.get_env("RABBIT_MQ_URI")],
           topology: [
             queues: [
               [name: "SCAN_REQUEST", durable: true],
               [name: "SCAN_RESULT", durable: true]
             ]
           ],
           producer: [pool_size: 10],
           consumers: [
             [queue: "SCAN_RESULT"]
           ]
         ]}
      ],
      else: []
  end
end
