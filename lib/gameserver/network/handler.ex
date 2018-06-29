defmodule Gameserver.Network.Handler do
  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, opts = []) do
    :ok = :ranch.accept_ack(ref)

    # Configure header size
    transport_options = Keyword.put(opts, :packet, 2)
    transport.setopts(socket, transport_options)

    loop(socket, transport)
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 60000) do
      {:ok, payload} ->
        spawn(fn -> Gameserver.Network.Packet.process(transport, payload) end)
        loop(socket, transport)

      {:error, :closed} ->
        IO.puts("Socket has been closed")
        shutdown(socket, transport)

      {:error, message} ->
        IO.puts("Connection closed unexpectedly (#{message})")
        shutdown(socket, transport)

      _ ->
        shutdown(socket, transport)
    end
  end

  defp shutdown(socket, transport) do
    :ok = transport.close(socket)
  end
end
