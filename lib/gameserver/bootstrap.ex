defmodule Gameserver.Bootstrap do
  @moduledoc """
  Bootstrap module will setup everything and startup.
  """

  @server Application.get_env(:gameserver, :server)

  @doc """
  Initializes server on the provided `port` and configure initial state
  """
  def init(port \\ @server["port"]) do
    # Initializing state
    initState()

    # Opening the socket
    IO.puts("Initializing server on localhost:#{port}")
    server = Socket.TCP.listen!(port, packet: :line)

    # Wait for messages
    spawn(fn ->
      accept(server)
    end)
  end

  defp initState() do
    Gameserver.State.Players.create()
  end

  defp accept(server) do
    # Waiting for players
    client = server |> Socket.accept!()

    # When messages arrive we will dispatch another process to handle them
    spawn(fn ->
      client |> Socket.Stream.send!(client |> Socket.Stream.recv!)
      client |> Socket.Stream.close
    end)

    # Waits for messages again
    accept(server)
  end
end
