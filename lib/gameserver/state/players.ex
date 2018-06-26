defmodule Gameserver.State.Players do
  use GenServer

  def create(players_list \\ []) do
    GenServer.start(__MODULE__, players_list, name: :players)
  end

  def attach(player) do
    GenServer.cast(:players, {:attach, player})
  end

  def detach(player) do
    GenServer.cast(:players, {:detach, player})
  end

  def update(player) do
    GenServer.cast(:players, {:update, player})
  end

  def get() do
    GenServer.call(:players, :get)
  end

  def init(players_list) do
    {:ok, players_list}
  end

  def handle_cast({:attach, player}, players) do
    {:noreply, players ++ [player]}
  end

  def handle_cast({:detach, player}, players) do
    {:noreply, Enum.filter(players, fn p -> p.id != player.id end)}
  end

  def handle_cast({:update, player}, players) do
    {:noreply, Enum.map(players, fn p -> if p.id == player.id, do: player, else: p end)}
  end

  def handle_call(:get, _from, players) do
    {:reply, players, players}
  end
end
