defmodule DndgameWeb.StatsController do
  use DndgameWeb, :controller

  alias Dndgame.Armors
  alias Dndgame.Weapons
  alias Dndgame.Races
  alias Dndgame.Classes

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    IO.inspect(conn.params)
    render_stats(conn, conn.params)
  end

  def render_stats(conn, %{"race_id" => race_id, "class_id" => class_id,
    "dex" => dex, "con" => con, "armor_id" => armor_id, "weapon_id" => weapon_id}) do
    {dex, _} = Integer.parse(dex)
    {con, _} = Integer.parse(con)
    armor = Armors.get_armor!(armor_id)
    class = Classes.get_class!(class_id)
    race = Races.get_race!(race_id)
    weapon = Weapons.get_weapon!(weapon_id)
    character = %{
      exp: 0,
      armor: armor,
      class: class,
      race: race,
      weapon: weapon,
      dex: dex,
      con: con,
    }
    render(conn, "stats.json", character: character)
  end
end
