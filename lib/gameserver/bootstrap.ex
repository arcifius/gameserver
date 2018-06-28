defmodule Gameserver.Bootstrap do
  require Logger

  @moduledoc """
  Bootstrap module will setup everything and startup.
  """

  @server Application.get_env(:gameserver, :server)

  @doc """
  Initializes server on the provided `port` and configure initial state
  """
  def init(port \\ @server.port) do
    # Initializing state
    initState()

    # Opening the socket
    IO.puts("Initializing server on localhost:#{port}")

    case :gen_tcp.listen(port, [:binary, active: true, reuseaddr: true]) do
      {:ok, socket} ->
        Logger.info("Waiting for players")
        accept_connection(socket)

      {:error, reason} ->
        Logger.error("Could not initialize server: #{reason}")
    end
  end

  defp initState() do
    Gameserver.State.Players.create()
  end

  defp accept_connection(server) do
    # Waiting for players
    {:ok, client} = :gen_tcp.accept(server)

    # When a new player arrives we will dispatch a process to attend him
    pid = spawn(fn -> Gameserver.Network.Player.wait() end)
    :gen_tcp.controlling_process(client, pid)

    # Back to waiting for players
    accept_connection(server)
  end
end
