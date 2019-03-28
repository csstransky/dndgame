defmodule DndgameWeb.SpellView do
  use DndgameWeb, :view
  alias DndgameWeb.SpellView

  def render("index.json", %{spells: spells}) do
    %{data: render_many(spells, SpellView, "spell.json")}
  end

  def render("show.json", %{spell: spell}) do
    %{data: render_one(spell, SpellView, "spell.json")}
  end

  def render("spell.json", %{spell: spell}) do
    %{id: spell.id,
      name: spell.name,
      desc: spell.desc,
      level_req: spell.level_req,
      type: spell.type,
      mp_cost: spell.mp_cost,
      dice: spell.dice,
      dice_bonus: spell.dice_bonus,
      target: spell.target}
  end
end
