defmodule DndgameWeb.MonsterView do
  use DndgameWeb, :view
  alias DndgameWeb.MonsterView

  def render("index.json", %{monsters: monsters}) do
    %{data: render_many(monsters, MonsterView, "monster.json")}
  end

  def render("show.json", %{monster: monster}) do
    %{data: render_one(monster, MonsterView, "monster.json")}
  end

  def render("monster.json", %{monster: monster}) do
    %{id: monster.id,
      name: monster.name,
      desc: monster.desc,
      hp: monster.hp,
      prof_bonus: monster.prof_bonus,
      initiative: monster.initiative,
      ac: monster.ac,
      mp: monster.mp,
      sp: monster.sp,
      type: monster.type}
  end
end
