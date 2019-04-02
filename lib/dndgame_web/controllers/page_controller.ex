defmodule DndgameWeb.PageController do
  use DndgameWeb, :controller

  # Make this match with %{"gameName" => gameName, "playerName" => playerName}
  def game(conn, opts) do
    gameName = "test"
    playerName = "test"
    render conn, "game.html", gameName: gameName, playerName: playerName
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
