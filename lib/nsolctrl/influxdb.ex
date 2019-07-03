defmodule InfluxDB do
  use GenServer

  #  defstruct sensor: nil, temp: nil

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def put(sensor, temp) do
    GenServer.cast(__MODULE__, {:put, sensor, temp})
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def stop() do
    send(__MODULE__, :stop)
  end

  def init(_) do
    #    :timer.send_interval(5000, :cleanup)
    # {:ok, %SimpleCtrl{}}
    {:ok, {}}
  end

  def handle_cast({:put, sensor, temp}, state) do
    {:noreply, %{state | sensor: sensor, temp: temp}}
  end

  def handle_call({:get}, _, state) do
    {:reply, state, state}
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

