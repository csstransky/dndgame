defmodule DndgameWeb.GamesChannel do
  use DndgameWeb, :channel

  alias Dndgame.Game
  alias Dndgame.BackupAgent

  intercept ["update_players"]

  def join("games:" <> name, payload, socket) do
    IO.inspect("BRING ME THE CORPSES OF THOSE WHO FOUGHT")
    if authorized?(payload) do
      game = BackupAgent.get(name) || Game.new_world(name)
      player = Map.get(payload, "user")
      game = game
      |> Dndgame.Game.add_to_lobby(player)
      |> Dndgame.Game.add_name(name)
      BackupAgent.put(name, game)
      update_players(name, player)

      socket = socket
        |> assign(:player, player)
        |> assign(:game, game)
        |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("start_game", _payload, socket) do
    name = socket.assigns[:name]
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
    name = socket.assigns[:name]

    game = Game.play_next_game(BackupAgent.get(name))
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)

    player = socket.assigns[:player]
    update_players(name, player)

    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
  end

  def handle_out("update_players", game, socket) do
    player = socket.assigns[:player]
    name = socket.assigns[:name]

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
