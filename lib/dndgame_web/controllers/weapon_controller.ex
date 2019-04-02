defmodule DndgameWeb.WeaponController do
  use DndgameWeb, :controller

  alias Dndgame.Weapons
  alias Dndgame.Weapons.Weapon

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    if conn.request_path == "/ajax/v1/select_weapons/" do
      select_weapons(conn, conn.params)
    else
      weapons = Weapons.list_weapons()
      render(conn, "index.json", weapons: weapons)
    end
  end

  def create(conn, %{"weapon" => weapon_params}) do
    with {:ok, %Weapon{} = weapon} <- Weapons.create_weapon(weapon_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.weapon_path(conn, :show, weapon))
      |> render("show.json", weapon: weapon)
    end
  end

  def show(conn, %{"id" => id}) do
    weapon = Weapons.get_weapon!(id)
    render(conn, "show.json", weapon: weapon)
  end

  def update(conn, %{"id" => id, "weapon" => weapon_params}) do
    weapon = Weapons.get_weapon!(id)

    with {:ok, %Weapon{} = weapon} <- Weapons.update_weapon(weapon, weapon_params) do
      render(conn, "show.json", weapon: weapon)
    end
  end

  def delete(conn, %{"id" => id}) do
    weapon = Weapons.get_weapon!(id)

    with {:ok, %Weapon{}} <- Weapons.delete_weapon(weapon) do
      send_resp(conn, :no_content, "")
    end
  end

  def select_weapons(conn, %{"race_id" => race_id, "class_id" => class_id}) do
    weapons = Weapons.list_weapons()
    class = Dndgame.Classes.get_class!(class_id)
    race = Dndgame.Races.get_race!(race_id)
    select_weapons = Dndgame.Weapons.get_select_weapons(weapons, race, class)
    render(conn, "index.json", weapons: select_weapons)
  end
end
