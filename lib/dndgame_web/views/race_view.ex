defmodule DndgameWeb.RaceView do
  use DndgameWeb, :view
  alias DndgameWeb.RaceView

  def render("index.json", %{races: races}) do
    %{data: render_many(races, RaceView, "race.json")}
  end

  def render("show.json", %{race: race}) do
    %{data: render_one(race, RaceView, "race.json")}
  end

  def render("race.json", %{race: race}) do
    %{id: race.id,
      name: race.name,
      desc: race.desc,
      str_bonus: race.str_bonus,
      dex_bonus: race.dex_bonus,
      con_bonus: race.con_bonus,
      int_bonus: race.int_bonus,
      wis_bonus: race.wis_bonus,
      cha_bonus: race.cha_bonus,
      size: race.size}
  end
end
