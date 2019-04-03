defmodule DndgameWeb.PageController do
  use DndgameWeb, :controller

  # Make this match with %{"gameName" => gameName, "playerName" => playerName}
  def game(conn, %{"user_id" => user_id, "world" => world}) do
    gameName = world
    playerName = user_id
    render conn, "game.html", gameName: gameName, playerName: playerName
  end

  def party(conn, %{"user_id" => user_id, "world_name" => world_name}) do
    characters = Dndgame.Characters.list_user_characters(user_id)
    render conn, "party.html", characters: characters, world_name: world_name
  end

  def worlds(conn, _params) do
    render conn, "worlds.html"
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end


end
