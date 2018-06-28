defmodule Gameserver.Network.Message do
  alias Gameserver.Structs
  alias Gameserver.Utils

  def read_header(packet) do
    <<header::size(16), _data::binary>> = packet
    header
  end

  def read_payload(packet, payload_size) do
    <<_header::size(16), data::size(payload_size)-bytes>> = packet
    data
  end

  def deserialize(packet) do
    with {:ok, data} <- MessagePack.unpack(packet) do
      {:ok, Utils.Transform.to_struct(%Structs.Packet{}, data)}
    end
  end

  def serialize(data) do
    {:ok, bin} = MessagePack.pack(data)
    fbin = <<0, byte_size(bin)>> <> bin
    {:ok, fbin}
  end
end
