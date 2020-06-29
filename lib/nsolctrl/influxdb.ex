defmodule InfluxDB do
@doc ~S"""
  Play with Influx database.

    iex> db = InfluxDB.start
    iex> InfluxDB.put(45, 46)
    iex> InfluxDB.get()
    [{45, 46}]
    iex> InfluxDB.reset_state()
    []


"""
  use GenServer
  require Logger

  #  defstruct sensor: nil, temp: nil
  @influxdb_url   Application.get_env(:influxdb, :url)

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

  def reset_state() do
    GenServer.call(__MODULE__, {:reset_state})
  end

  def stop() do
    send(__MODULE__, :stop)
  end

  def init(_) do
    #    :timer.send_interval(5000, :cleanup)
    # {:ok, %SimpleCtrl{}}
    {:ok, []}
  end

  def handle_cast({:put, sensor, temp}, state) do
    # {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, _body} =
    #    :httpc.request(:get, {'http://google.com', []}, [], [])
    
    data = 'temperature,machine=unit43,type=test external=#{sensor},internal=#{temp}'

    # :httpc.request(:post, {'http://localhost:8086/write?db=mydb', [], 'application/binary', data}, [], [])
    IO.inspect :httpc.request(:post, {'#{@influxdb_url}write?db=mydb', [], 'application/binary', data}, [], [])

    IO.puts data
    Logger.info data
    IO.puts @influxdb_url

    {:noreply, [ {sensor, temp} | state ] }
  end

  def handle_call({:get}, _, state) do
    {:reply, state, state}
  end

  def handle_info(:cleanup, state) do
    IO.puts "Cleanup..."
    {:noreply, state}
  end

  def handle_info(:reset_state, state) do
    IO.puts "Reset state"
    {:noreply, []}
  end

  def handle_info(:stop, state) do
    IO.puts "Stopping..."
    {:stop, :normal, state}
  end
end

