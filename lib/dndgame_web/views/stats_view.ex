defmodule DndgameWeb.StatsView do
  use DndgameWeb, :view
  alias DndgameWeb.StatsView

  alias Dndgame.Characters

  def render("show.json", %{character: character}) do
    %{data: render_one(character, StatsView, "stats.json")}
  end

  def render("stats.json", %{character: character}) do
    %{data:
      %{
        hp: Characters.get_hp(character),
        ac: Characters.get_ac(character),
        mp: Characters.get_mp(character),
        sp: Characters.get_sp(character),
        initiative: Characters.get_initiative(character),
      }
    }
  end
end
