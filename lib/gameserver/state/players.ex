defmodule Gameserver.State.Players do
  use GenServer

  @doc """
    Creates the state.
    MUST BE CALLED BEFORE ANYTHING.

    Returns
    `{:ok, pid}` when sucessfully created.
    `{:error, reason}` when something went wrong.
  """
  def create(players_list \\ []) do
    GenServer.start(__MODULE__, players_list, name: :players)
  end

  @doc """
    Clears state.

    Returns `:ok`
  """
  def clear() do
    GenServer.cast(:players, :clear)
  end

  @doc """
    Attaches a player to state.

    Returns
    `:ok` when provided player is attached sucessfully.
    `:invalid_format` when provided player isnt Player Struct compliant.
    `:already_attached` when provided player id is already on state.
  """
  def attach(player) do
    try do
      # Check if provided player matches Player Struct
      %Gameserver.Structs.Player{} = player

      # Check if provided player id isnt attached
      if Enum.any?(Gameserver.State.Players.get(), fn p -> p.id == player.id end) do
        :already_attached
      else
        GenServer.cast(:players, {:attach, player})
      end
    rescue
      MatchError -> :invalid_format
    end
  end

  @doc """
    Detaches a player from state.

    Returns
    `:ok` when the provided player isnt present on state or was detached sucessfully.
    `:invalid_format` when provided player isnt Player Struct compliant.
  """
  def detach(player) do
    try do
      # Check if provided player matches Player Struct
      %Gameserver.Structs.Player{} = player

      GenServer.cast(:players, {:detach, player})
    rescue
      MatchError -> :invalid_format
    end
  end

  @doc """
    Updates a player from state with provided player.
    DO NOT CHANGE PLAYER ID.

    Returns
    `:ok` when the player gets updated with the information from provided player.
    `:not_found` when provided player isnt attached on state.
    `:invalid_format` when provided player isnt Player Struct compliant.
  """
  def update(player) do
    try do
      # Check if provided player matches Player Struct
      %Gameserver.Structs.Player{} = player

      # Check if provided player id is attached
      if Enum.any?(Gameserver.State.Players.get(), fn p -> p.id == player.id end) do
        GenServer.cast(:players, {:update, player})
      else
        :not_found
      end
    rescue
      MatchError -> :invalid_format
    end
  end

  @doc """
    Gets all attached players on state.

    Returns
    `[Gameserver.Structs.Player ... ]` when the player gets updated with the information from provided player.
  """
  def get() do
    GenServer.call(:players, :get)
  end

  @impl true
  def init(players_list) do
    {:ok, players_list}
  end

  @impl true
  def handle_cast({:attach, player}, players) do
    {:noreply, players ++ [player]}
  end

  @impl true
  def handle_cast({:detach, player}, players) do
    {:noreply, Enum.filter(players, fn p -> p.id != player.id end)}
  end

  @impl true
  def handle_cast({:update, player}, players) do
    {:noreply, Enum.map(players, fn p -> if p.id == player.id, do: player, else: p end)}
  end

  @impl true
  def handle_cast(:clear, _players) do
    {:noreply, []}
  end

  @impl true
  def handle_call(:get, _from, players) do
    {:reply, players, players}
  end
end
