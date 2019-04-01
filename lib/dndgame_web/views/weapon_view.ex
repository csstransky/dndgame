defmodule DndgameWeb.WeaponView do
  use DndgameWeb, :view
  alias DndgameWeb.WeaponView

  def render("index.json", %{weapons: weapons}) do
    %{data: render_many(weapons, WeaponView, "weapon.json")}
  end

  def render("show.json", %{weapon: weapon}) do
    %{data: render_one(weapon, WeaponView, "weapon.json")}
  end

  def render("weapon.json", %{weapon: weapon}) do
    %{id: weapon.id,
      name: weapon.name,
      desc: weapon.desc,
      weapon_category: weapon.weapon_category,
      attack: DndgameWeb.AttackView.render("attack.json", %{attack: weapon.attack}),
    }
  end
end
