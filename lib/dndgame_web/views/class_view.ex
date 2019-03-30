defmodule DndgameWeb.ClassView do
  use DndgameWeb, :view
  alias DndgameWeb.ClassView

  def render("index.json", %{classes: classes}) do
    %{data: render_many(classes, ClassView, "class.json")}
  end

  def render("show.json", %{class: class}) do
    %{data: render_one(class, ClassView, "class.json")}
  end

  def render("class.json", %{class: class}) do
    IO.inspect(class)
    %{id: class.id,
      name: class.name,
      desc: class.desc,
      ability_modifier: class.ability_modifier,
      hit_die: class.hit_die,
      prof_array: class.prof_array,
      save_array: class.save_array,
      weapon_prof_array: class.weapon_prof_array,
      armor_prof_array: class.armor_prof_array,
    }
  end
end
