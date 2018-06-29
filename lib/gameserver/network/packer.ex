defmodule Gameserver.Network.Packer do
  alias Gameserver.Structs
  alias Gameserver.Utils

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
