defmodule DndgameWeb.MonsterController do
  use DndgameWeb, :controller

  alias Dndgame.Monsters
  alias Dndgame.Monsters.Monster

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    monsters = Monsters.list_monsters()
    render(conn, "index.json", monsters: monsters)
  end

  def create(conn, %{"monster" => monster_params}) do
    with {:ok, %Monster{} = monster} <- Monsters.create_monster(monster_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.monster_path(conn, :show, monster))
      |> render("show.json", monster: monster)
    end
  end

  def show(conn, %{"id" => id}) do
    monster = Monsters.get_monster!(id)
    render(conn, "show.json", monster: monster)
  end

  def update(conn, %{"id" => id, "monster" => monster_params}) do
    monster = Monsters.get_monster!(id)

    with {:ok, %Monster{} = monster} <- Monsters.update_monster(monster, monster_params) do
      render(conn, "show.json", monster: monster)
    end
  end

  def delete(conn, %{"id" => id}) do
    monster = Monsters.get_monster!(id)

    with {:ok, %Monster{}} <- Monsters.delete_monster(monster) do
      send_resp(conn, :no_content, "")
    end
  end
end
