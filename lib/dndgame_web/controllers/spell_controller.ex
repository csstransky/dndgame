defmodule DndgameWeb.SpellController do
  use DndgameWeb, :controller

  alias Dndgame.Spells
  alias Dndgame.Spells.Spell

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    spells = Spells.list_spells()
    render(conn, "index.json", spells: spells)
  end

  def create(conn, %{"spell" => spell_params}) do
    with {:ok, %Spell{} = spell} <- Spells.create_spell(spell_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.spell_path(conn, :show, spell))
      |> render("show.json", spell: spell)
    end
  end

  def show(conn, %{"id" => id}) do
    spell = Spells.get_spell!(id)
    render(conn, "show.json", spell: spell)
  end

  def update(conn, %{"id" => id, "spell" => spell_params}) do
    spell = Spells.get_spell!(id)

    with {:ok, %Spell{} = spell} <- Spells.update_spell(spell, spell_params) do
      render(conn, "show.json", spell: spell)
    end
  end

  def delete(conn, %{"id" => id}) do
    spell = Spells.get_spell!(id)

    with {:ok, %Spell{}} <- Spells.delete_spell(spell) do
      send_resp(conn, :no_content, "")
    end
  end
end
