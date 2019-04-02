defmodule DndgameWeb.AttackView do
  use DndgameWeb, :view
  alias DndgameWeb.AttackView

  def render("index.json", %{attacks: attacks}) do
    %{data: render_many(attacks, AttackView, "attack.json")}
  end

  def render("show.json", %{attack: attack}) do
    %{data: render_one(attack, AttackView, "attack.json")}
  end

  def render("attack.json", %{attack: attack}) do
    %{id: attack.id,
      name: attack.name,
      desc: attack.desc,
      attack_bonus: attack.attack_bonus,
      type: attack.type,
      damage_dice: attack.damage_dice,
      damage_bonus: attack.damage_bonus,
      target: attack.target}
  end
end
