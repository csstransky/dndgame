defmodule DndgameWeb.AttackController do
  use DndgameWeb, :controller

  alias Dndgame.Attacks
  alias Dndgame.Attacks.Attack

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    attacks = Attacks.list_attacks()
    render(conn, "index.json", attacks: attacks)
  end

  def create(conn, %{"attack" => attack_params}) do
    with {:ok, %Attack{} = attack} <- Attacks.create_attack(attack_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.attack_path(conn, :show, attack))
      |> render("show.json", attack: attack)
    end
  end

  def show(conn, %{"id" => id}) do
    attack = Attacks.get_attack!(id)
    render(conn, "show.json", attack: attack)
  end

  def update(conn, %{"id" => id, "attack" => attack_params}) do
    attack = Attacks.get_attack!(id)

    with {:ok, %Attack{} = attack} <- Attacks.update_attack(attack, attack_params) do
      render(conn, "show.json", attack: attack)
    end
  end

  def delete(conn, %{"id" => id}) do
    attack = Attacks.get_attack!(id)

    with {:ok, %Attack{}} <- Attacks.delete_attack(attack) do
      send_resp(conn, :no_content, "")
    end
  end
end
