defmodule DndgameWeb.GamesChannel do
  use DndgameWeb, :channel

  alias Dndgame.Game
  alias Dndgame.Game.World
  alias Dndgame.BackupAgent

  intercept ["update_players"]

  def join("games:" <> name, payload, socket) do
    IO.inspect("BRING ME THE CORPSES OF THOSE WHO FOUGHT")
    IO.inspect(payload)
    IO.inspect(socket)
    if authorized?(payload) do
      world = BackupAgent.get(name) || World.new_world(name)
      playerName = Map.get(payload, "user")
      partyId1 = Map.get(payload, "partyId1")
      partyId2 = Map.get(payload, "partyId2")
      partyId3 = Map.get(payload, "partyId3")
      world = World.join_world(world, playerName)
      game = BackupAgent.get(playerName) || Game.new_game(world)
      |> Game.create_party(partyId1, partyId2, partyId3)
      |> Game.update_game_world(world)
      IO.inspect(game)
      BackupAgent.put(name, world)
      BackupAgent.put(playerName, game)
      update_players(name, playerName)
      IO.inspect(BackupAgent.get(playerName))
      socket = socket
        |> assign(:player, playerName)
        |> assign(:game, game)
        |> assign(:worldName, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("start_game", _payload, socket) do
    name = socket.assigns[:worldName]
    game = BackupAgent.get(name) || socket.assigns[:game]

    if length(game.lobbyList) >= 2 do
      game = Game.start_game(game)
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)

      player = socket.assigns[:player]
      update_players(name, player)

      Dndgame.GameServer.start(name)
      {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    else
      {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
    end
  end

  def handle_in("play_next_game", _map, socket) do
    name = socket.assigns[:worldName]

    game = Game.play_next_game(BackupAgent.get(name))
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)

    player = socket.assigns[:player]
    update_players(name, player)

    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_out("update_players", game, socket) do
    player = socket.assigns[:player]
    name = socket.assigns[:worldName]

    if player && name do
      push socket, "update", Game.client_view(game)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def update_players(name, player) do
    if player do
      game = BackupAgent.get(name)
      DndgameWeb.Endpoint.broadcast!("games:#{name}", "update_players", game)
      {:ok, game}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
