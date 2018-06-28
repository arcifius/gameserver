defmodule Gameserver.Network.Player do
  require Logger
  alias Gameserver.Network

  def wait() do
    Logger.info("Waiting for client messages")

    receive do
      {:tcp, _socket, packet} ->
        with payload_size <- Network.Message.read_header(packet),
             payload <- Network.Message.read_payload(packet, payload_size) do
          {:ok, data} = Network.Message.deserialize(payload)

          case Network.Protocol.resolve(data.i) do
            :login ->
              IO.puts("Login")

            _ ->
              IO.puts("Unsupported #{data.i}")
          end
        end

        wait()

      {:tcp_closed, _socket} ->
        IO.puts("Socket has been closed")

      {:tcp_error, _socket, reason} ->
        IO.puts("connection closed due to #{reason}")
    end
  end
end
