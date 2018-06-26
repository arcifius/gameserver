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
    server = Socket.UDP.open!(port)

    # Wait for messages
    spawn(fn -> listen(server) end)
  end

  defp initState() do
    Gameserver.State.Players.create()
  end

  defp listen(server) do
    # Waiting for messages
    {data, client} = server |> Socket.Datagram.recv!()

    # When messages arrive we will dispatch another process to handle them
    spawn(fn -> Gameserver.Network.Message.handle(data, client) end)

    # Waits for messages again
    listen(server)
  end
end
