defmodule Dndgame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # Dndgame.Repo,
      # Start the endpoint when the application starts
      DndgameWeb.Endpoint,
      # Starts a worker by calling: Dndgame.Worker.start_link(arg)
      # {Dndgame.Worker, arg},
      Dndgame.GameSup,
      Dndgame.BackupAgent,
      Dndgame.GameServer,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dndgame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DndgameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
