defmodule Gameserver.Client do
  @moduledoc """
  Client module will aid in testing server.
  This will also give an idea of how a client should work in
  other languages.
  """

  @server Application.get_env(:gameserver, :server)

  def init() do
    {:ok, socket} = :gen_tcp.connect(@server.address, @server.port, [:binary, active: false, reuseaddr: true])

    execute(socket)
  end

  def execute(sock) do
    auth_packet = %{
      i: Gameserver.Network.Protocol.resolve(:login),
      d: %{u: "arcifius", p: "123456"}
    }

    {:ok, bin} = Gameserver.Network.Message.serialize(auth_packet)

    sock |> :gen_tcp.send(bin)

    case :gen_tcp.recv(sock, 0) do
      {:ok, data} ->
        IO.puts(data)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end
