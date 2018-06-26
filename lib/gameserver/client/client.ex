defmodule Gameserver.Client do
  @server Application.get_env(:gameserver, :server)

  @doc """
    Sends `data` to the `to` value, where `to` is a tuple of
    { host, port } like {{127, 0, 0, 1}, 1337}
  """
  def push(data, to) do
    # Without specifying the port, we randomize it
    server = Socket.UDP.open!()
    Socket.Datagram.send!(server, data, to)
  end

  @doc """
    Sends `data` to the default server and port
  """
  def push(data) do
    push(data, {@server["address"], @server["port"]})
  end
end
