defmodule NSolCtrl.Led do

  use GenServer

  @gpio_pin 18

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
    {:ok, gpio} = Circuits.GPIO.open(@gpio_pin, :output)

    # :timer.send_interval(5000, :cleanup)
    {:ok, {gpio}}
  end

  def turn_on() do
    GenServer.cast(__MODULE__, {:turn_on})
  end

  def turn_off() do
    GenServer.cast(__MODULE__, {:turn_off})
  end

  def handle_cast({:turn_on}, {gpio} = state) do
    Circuits.GPIO.write(gpio, 1)
    {:noreply, state}
  end

  def handle_cast({:turn_off}, {gpio} = state) do
    Circuits.GPIO.write(gpio, 0)
    {:noreply, state}
  end
end
