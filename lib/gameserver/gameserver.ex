defmodule Gameserver do
  require Logger
  use Application

  @doc """
  Bootstrap server
  """
  def start(_type, _args) do
    children = [
      Gameserver.State.Players,
      Gameserver.Network.Worker
    ]

    opts = [strategy: :one_for_one, name: Gameserver.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
