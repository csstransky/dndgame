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
    %{id: class.id,
      name: class.name,
      desc: class.desc,
      ability_modifier: class.ability_modifier,
      hit_die: class.hit_die,
      prof_array: class.prof_array,
      save_array: class.save_array,
      weapon_prof_array: class.weapon_prof_array,
      armor_prof_array: class.armor_prof_array,
      skills: Enum.map(class.skills,
        fn skill ->
          DndgameWeb.SkillView.render("skill.json", %{skill: skill})
        end),
      spells: Enum.map(class.spells,
        fn spell ->
          DndgameWeb.SpellView.render("spell.json", %{spell: spell})
        end),
    }
  end
end
