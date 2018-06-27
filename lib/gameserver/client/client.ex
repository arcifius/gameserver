defmodule Gameserver.Client do
  @server Application.get_env(:gameserver, :server)

  @doc """
    Sends `data` to the default server and port
  """
  def push(data) do
    sock = Socket.TCP.connect!(@server["address"], @server["port"], packet: :line)
    sock |> Socket.Stream.send!(data)
  end
end
