defmodule GameserverTest.Network.Message do
  use ExUnit.Case

  doctest Gameserver.Network.Message

  @packet %{d: [15, 15, 0], i: 1, s: 123_213}
  @binaryPacket <<218, 0, 32, 123, 34, 115, 34, 58, 49, 50, 51, 50, 49, 51, 44, 34, 105, 34, 58,
                  49, 44, 34, 100, 34, 58, 91, 49, 53, 44, 49, 53, 44, 48, 93, 125>>

  test "it should serialize data" do
    {:ok, packet} = Gameserver.Network.Message.serialize(@packet)
    assert packet
    assert packet == @binaryPacket
  end

  test "it should parse data from binary packet" do
    {:ok, packet} = Gameserver.Network.Message.deserialize(@binaryPacket)

    assert packet
    assert packet["s"] == 123_213
    assert packet["i"] == 1
    assert packet["d"] == [15, 15, 0]
  end
end
