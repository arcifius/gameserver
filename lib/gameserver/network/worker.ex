defmodule Gameserver.Network.Worker do
  @server Application.get_env(:gameserver, :server)

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker
    }
  end

  def start_link do
    # Initializing server
    IO.puts("Initializing server on #{@server.port}")

    # Server options
    opts = [
      port: @server.port
    ]

    {:ok, _} =
      :ranch.start_listener(
        :game_server,
        10,
        :ranch_tcp,
        opts,
        Gameserver.Network.Handler,
        []
      )
  end
end
