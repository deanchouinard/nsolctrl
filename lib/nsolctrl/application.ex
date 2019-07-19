defmodule NSolCtrl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting NSolCtrl...")
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NSolCtrl.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: NSolCtrl.Worker.start_link(arg)
      # {NSolCtrl.Worker, arg},
      {TestServer, []},
      {NSolCtrl.Led, nil}
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: NSolCtrl.Worker.start_link(arg)
      # {NSolCtrl.Worker, arg},
      {NSolCtrl.Led, nil}
    ]
  end
end
