defmodule DndgameWeb.GamesChannel do
  use DndgameWeb, :channel

  alias Dndgame.Game
  alias Dndgame.Game.World
  alias Dndgame.BackupAgent

  intercept ["update_players"]

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do

      world = BackupAgent.get(name) || World.new_world(name)
      playerName = Map.get(payload, "user")
      world = World.join_world(world, playerName)

      game = BackupAgent.get(playerName) || Game.new_game(world)
      partyId1 = Map.get(payload, "partyId1")
      partyId2 = Map.get(payload, "partyId2")
      partyId3 = Map.get(payload, "partyId3")
      game = game
      |> Game.create_party(partyId1, partyId2, partyId3)
      |> Game.update_game_world(world)
      BackupAgent.put(name, world)
      BackupAgent.put(playerName, game)
      update_players(name, playerName)
      socket = socket
        |> assign(:playerName, playerName)
        |> assign(:worldName, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("walk", directionInt, socket) do
    worldName = socket.assigns[:worldName]
    playerName = socket.assigns[:playerName]
    world = BackupAgent.get(worldName)
    # TODO, you may need to change this
    game = BackupAgent.get(playerName)
    |> Game.walk(directionInt)
    world = Map.put_new(world, :playerPosns, game.playerPosns)
    BackupAgent.put(worldName, world)
    BackupAgent.put(playerName, game)
    update_players(worldName, playerName)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("attack", enemyIndex, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.attack(enemyIndex)
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("use_skill", %{"skillId" => skillId, "enemyIndex" => enemyIndex}, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.use_skill(skillId, enemyIndex)
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("use_spell", %{"spellId" => spellId, "enemyIndex" => enemyIndex}, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.use_spell(spellId, enemyIndex)
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("run", _payload, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.run()
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("death_save", _payload, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.death_save()
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("enemy_attack", characterIndex, socket) do
    playerName = socket.assigns[:playerName]
    game = BackupAgent.get(playerName)
    |> Game.enemy_attack(characterIndex)
    BackupAgent.put(playerName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_in("start_game", _payload, socket) do
    name = socket.assigns[:worldName]
    game = BackupAgent.get(name) || socket.assigns[:game]

    if length(game.lobbyList) >= 2 do
      game = Game.start_game(game)
      socket = assign(socket, :game, game)
      BackupAgent.put(name, game)

      player = socket.assigns[:playerName]
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

    player = socket.assigns[:playerName]
    update_players(name, player)

    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_out("update_players", world, socket) do
    playerName = socket.assigns[:playerName]
    worldName = socket.assigns[:worldName]

    if playerName && worldName do
      game = BackupAgent.get(playerName)
      |> Game.update_game_world(world)
      push socket, "update", Game.client_view(game)
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def update_players(worldName, playerName) do
    if playerName do
      # I'm doing this here so backup agent is only called once for world
      world = BackupAgent.get(worldName)
      DndgameWeb.Endpoint.broadcast!("games:#{worldName}", "update_players", world)
      {:ok, world}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
