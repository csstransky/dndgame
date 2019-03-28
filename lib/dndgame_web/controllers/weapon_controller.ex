defmodule DndgameWeb.WeaponController do
  use DndgameWeb, :controller

  alias Dndgame.Weapons
  alias Dndgame.Weapons.Weapon

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    weapons = Weapons.list_weapons()
    render(conn, "index.json", weapons: weapons)
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
end
