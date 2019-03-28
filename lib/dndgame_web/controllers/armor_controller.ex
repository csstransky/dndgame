defmodule DndgameWeb.ArmorController do
  use DndgameWeb, :controller

  alias Dndgame.Armors
  alias Dndgame.Armors.Armor

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    armors = Armors.list_armors()
    render(conn, "index.json", armors: armors)
  end

  def create(conn, %{"armor" => armor_params}) do
    with {:ok, %Armor{} = armor} <- Armors.create_armor(armor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.armor_path(conn, :show, armor))
      |> render("show.json", armor: armor)
    end
  end

  def show(conn, %{"id" => id}) do
    armor = Armors.get_armor!(id)
    render(conn, "show.json", armor: armor)
  end

  def update(conn, %{"id" => id, "armor" => armor_params}) do
    armor = Armors.get_armor!(id)

    with {:ok, %Armor{} = armor} <- Armors.update_armor(armor, armor_params) do
      render(conn, "show.json", armor: armor)
    end
  end

  def delete(conn, %{"id" => id}) do
    armor = Armors.get_armor!(id)

    with {:ok, %Armor{}} <- Armors.delete_armor(armor) do
      send_resp(conn, :no_content, "")
    end
  end
end
