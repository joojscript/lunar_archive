defmodule Lunar.Services.Queue do
  use GenServer

  require Logger

  @type queue_state :: [
          instance: :queue.queue(any)
        ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    Logger.info("Queue Service initialized")
    {:ok, [instance: :queue.new()]}
  end

  def push(item), do: GenServer.call(__MODULE__, {:push, item})
  def pop, do: GenServer.call(__MODULE__, :pop)
  def peek, do: GenServer.call(__MODULE__, :peek)
  def size, do: GenServer.call(__MODULE__, :size)
  def empty?, do: GenServer.call(__MODULE__, :empty?)
  def clear, do: GenServer.call(__MODULE__, :clear)
  def to_list, do: GenServer.call(__MODULE__, :to_list)

  def handle_call({:push, item}, _from, state) do
    {:reply, :queue.in(item, state[:instance]), state}
  end

  def handle_call(:pop, _from, state) do
    {:reply, :queue.out(state[:instance]), state}
  end

  def handle_call(:peek, _from, state) do
    {:reply, :queue.peek(state[:instance]), state}
  end

  def handle_call(:size, _from, state) do
    {:reply, :queue.len(state[:instance]), state}
  end

  def handle_call(:empty?, _from, state) do
    {:reply, :queue.is_empty(state[:instance]), state}
  end

  def handle_call(:clear, _from, state) do
    {:reply, :queue.new(), state}
  end

  def handle_call(:to_list, _from, state) do
    {:reply, :queue.to_list(state[:instance]), state}
  end
end
