
defmodule TestServer do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def stop() do
    send(__MODULE__, :stop)
  end

  def init(_) do
    # :timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_info(:cleanup, state) do
    IO.puts "Cleanup..."
    {:noreply, state}
  end

  def handle_info(:stop, state) do
    IO.puts "Stopping..."
    {:stop, :normal, state}
  end
end
