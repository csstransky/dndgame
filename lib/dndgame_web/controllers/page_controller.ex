defmodule DndgameWeb.PageController do
  use DndgameWeb, :controller

  # Make this match with %{"gameName" => gameName, "playerName" => playerName}
  def game(conn, %{"user_id" => user_id, "world_name" => world_name,
    "party_id_1" => party_id_1,
    "party_id_2" => party_id_2,
    "party_id_3" => party_id_3}) do
    IO.inspect(conn)
    if (party_id_1 == party_id_2 && party_id_1 != "")
      || (party_id_1 == party_id_3 && party_id_1 != "")
      || (party_id_2 == party_id_3 && party_id_2 != "") do
        IO.inspect("What up my dude")
    end
    IO.inspect(party_id_1)
    IO.inspect(party_id_2)
    IO.inspect(party_id_3)
    IO.inspect(world_name)
    gameName = world_name
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
