defmodule NSolCtrl.Led do
  use GenServer

  require Logger

  #  @gpio_pin 4
  @red      17
  @green    18
  @blue     4

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def stop() do
    send(__MODULE__, :stop)
  end

  def init(_) do
    # {:ok, gpio} = Circuits.GPIO.open(@gpio_pin, :output)
    {:ok, red} = Circuits.GPIO.open(@red, :output)
    {:ok, green} = Circuits.GPIO.open(@green, :output)
    {:ok, blue} = Circuits.GPIO.open(@blue, :output)

    # :timer.send_interval(5000, :cleanup)
    # {:ok, {gpio}}
    {:ok, {red, green, blue }}
  end

  def turn_on(color) do
    GenServer.cast(__MODULE__, {:turn_on, color})
  end

  def turn_off(color) do
    GenServer.cast(__MODULE__, {:turn_off, color})
  end

  def blink() do
    for color <- [:red, :green, :blue] do
      GenServer.cast(__MODULE__, {:turn_on, color})
      Process.sleep(200)
      GenServer.cast(__MODULE__, {:turn_off, color})
      Process.sleep(200)
    end
  end

  def handle_cast({:turn_on, color}, state) do
    Circuits.GPIO.write(get_pin(color, state), 1)
    {:noreply, state}
  end

  def handle_cast({:turn_off, color}, state) do
    Circuits.GPIO.write(get_pin(color, state), 0)
    {:noreply, state}
  end

  def get_pin(color, {red, green, blue} = _state) do
    #    IO.puts(color, label: "get_pin:")
    case color do
      :red ->
        Logger.info("Getting red pin, #{inspect(red)}")
      :green ->
        green
      :blue ->
        blue
      _ ->
        red
    end
  end
end
