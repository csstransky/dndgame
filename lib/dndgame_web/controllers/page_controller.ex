defmodule DndgameWeb.PageController do
  use DndgameWeb, :controller

  # Make this match with %{"gameName" => gameName, "playerName" => playerName}
  def game(conn, %{"user_id" => user_id, "world_name" => world_name,
    "party_id_1" => party_id_1,
    "party_id_2" => party_id_2,
    "party_id_3" => party_id_3}) do
    cond do
      is_id_dups?(party_id_1, party_id_2, party_id_3) ->
        error = "You cannot choose the same character more than once."
        party(conn, %{"user_id" => user_id, "world_name" => world_name}, error)
      is_no_character_selected?(party_id_1, party_id_2, party_id_3) ->
        error = "You must select a character for your party."
        party(conn, %{"user_id" => user_id, "world_name" => world_name}, error)
      true ->
        render conn, "game.html", gameName: world_name,
          partyId1: party_id_1, partyId2: party_id_2, partyId3: party_id_3
    end
  end

  def party(conn, %{"user_id" => user_id, "world_name" => world_name}, error \\ nil) do
    if world_name == "" do
      # Including a safety if the user decides not to pick any worlds.
      world_name = "boston"
      characters = Dndgame.Characters.list_user_characters(user_id)
      render conn, "party.html", characters: characters, world_name: world_name, error: error
    else
      characters = Dndgame.Characters.list_user_characters(user_id)
      render conn, "party.html", characters: characters, world_name: world_name, error: error
    end
  end

  def worlds(conn, _params) do
    render conn, "worlds.html"
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    render(conn, "login.html")
  end

  def is_id_dups?(party_id_1, party_id_2, party_id_3) do
    (party_id_1 == party_id_2 && party_id_1 != "")
      || (party_id_1 == party_id_3 && party_id_1 != "")
      || (party_id_2 == party_id_3 && party_id_2 != "")
  end

  def is_no_character_selected?(party_id_1, party_id_2, party_id_3) do
    party_id_1 == "" && party_id_2 == "" && party_id_3 == ""
  end
end
