defmodule Gameserver.Network.Message do
  def handle(data, client) do
    IO.puts("#{data} from #{inspect(client)}")
  end

  def deserialize(packet) do
    {:ok, unpacked} = MessagePack.unpack(packet)
    Poison.Parser.parse(unpacked)
  end

  def serialize(data) do
    json = Poison.encode!(data)
    MessagePack.pack(json)
  end
end
