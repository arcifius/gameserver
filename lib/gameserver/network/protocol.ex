defmodule Gameserver.Network.Protocol do
  @version 1

  @messages [
    :login,
    :handshake_ok,
    :protocol_not_supported
  ]

  def resolve(source) do
    cond do
      is_number(source) ->
        Enum.at(@messages, source)

      is_atom(source) ->
        Enum.find_index(@messages, fn m -> m == source end)
    end
  end

  def version do
    @version
  end
end
