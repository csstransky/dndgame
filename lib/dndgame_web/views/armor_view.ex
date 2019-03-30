defmodule DndgameWeb.ArmorView do
  use DndgameWeb, :view
  alias DndgameWeb.ArmorView

  def render("index.json", %{armors: armors}) do
    %{data: render_many(armors, ArmorView, "armor.json")}
  end

  def render("show.json", %{armor: armor}) do
    %{data: render_one(armor, ArmorView, "armor.json")}
  end

  def render("armor.json", %{armor: armor}) do
    %{id: armor.id,
      name: armor.name,
      desc: armor.desc,
      armor_category: armor.armor_category,
      base: armor.base,
      dex_bonus: armor.dex_bonus,
      str_minimum: armor.str_minimum,
      stealth_disadvantage: armor.stealth_disadvantage}
  end

  def render("select_armors.json", %{armors: armors, race: race, class: class}) do
    select_armors = Dndgame.Armors.get_select_armors(armors, race, class)
    %{data: render_many(armors, ArmorView, "armor.json")}
  end
end
