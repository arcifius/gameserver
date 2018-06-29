defmodule Gameserver.Network.Packet do
  require Logger
  alias Gameserver.Network

  def process(transport, payload) do
    case Network.Packer.deserialize(payload) do
      {:ok, packet} ->
        handle_intent(transport, packet)

      _ ->
        Logger.error("Failed to deserialize payload into Packet Struct!")
    end
  end

  defp handle_intent(_transport, packet) do
    case Network.Protocol.resolve(packet.i) do
      :login ->
        Logger.info("Should login")

      :handshake ->
        Logger.info("Should check informations for handshake")

      :character_list ->
        Logger.info("Should return character list")

      _ ->
        Logger.error("Unsupported intent #{packet.i}")
    end
  end
end
