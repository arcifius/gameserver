defmodule GameserverTest.State.Players do
  use ExUnit.Case

  doctest Gameserver.State.Players

  setup do
    Gameserver.State.Players.create()
    Gameserver.State.Players.clear()
    :ok
  end

  @playerOne %Gameserver.Structs.Player{id: 1, name: "Arcifius", position: [0, 0, 0]}
  @playerTwo %Gameserver.Structs.Player{id: 2, name: "Belena", position: [0, 0, 0]}
  @playerThree %Gameserver.Structs.Player{id: 2, name: "Freya", position: [0, 0, 0]}

  test "it should accept only Player struct compliant for attachment" do
    assert Gameserver.State.Players.attach(@playerOne) == :ok
    assert Gameserver.State.Players.attach(%{id: 2, name: "Wix", position: []}) == :invalid_format
    assert Enum.count(Gameserver.State.Players.get()) == 1
  end

  test "it should refuse attachment when new player id is already present on state" do
    assert Gameserver.State.Players.attach(@playerTwo) == :ok
    assert Gameserver.State.Players.attach(@playerThree) == :already_attached
    assert Enum.count(Gameserver.State.Players.get()) == 1
  end

  test "it should retrieve all attached players on state" do
    assert Gameserver.State.Players.attach(@playerOne) == :ok
    assert Gameserver.State.Players.attach(@playerTwo) == :ok
    assert Enum.count(Gameserver.State.Players.get()) == 2
  end

  test "it should detach when provided player is attached" do
    assert Gameserver.State.Players.attach(@playerTwo) == :ok
    assert Enum.count(Gameserver.State.Players.get()) == 1
    assert Gameserver.State.Players.detach(@playerTwo) == :ok
    assert Enum.count(Gameserver.State.Players.get()) == 0
  end

  test "it should not detach when provided player is not Player Struct compliant" do
    assert Gameserver.State.Players.detach(%{id: 2, name: "Wix", position: []}) == :invalid_format
    assert Enum.count(Gameserver.State.Players.get()) == 0
  end

  test "it should not update when provided player is not Player Struct compliant" do
    assert Gameserver.State.Players.update(%{id: 2, name: "Wix", position: []}) == :invalid_format
    assert Enum.count(Gameserver.State.Players.get()) == 0
  end

  test "it should update player with provided player when id matches" do
    assert Gameserver.State.Players.attach(@playerTwo) == :ok
    assert Enum.count(Gameserver.State.Players.get()) == 1
    assert Gameserver.State.Players.update(@playerThree) == :ok
    assert Enum.count(Gameserver.State.Players.get()) == 1

    [h | _] = Gameserver.State.Players.get()
    assert h.name == @playerThree.name
  end
end
