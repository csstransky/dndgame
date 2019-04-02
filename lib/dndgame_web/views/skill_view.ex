defmodule DndgameWeb.SkillView do
  use DndgameWeb, :view
  alias DndgameWeb.SkillView

  def render("index.json", %{skills: skills}) do
    %{data: render_many(skills, SkillView, "skill.json")}
  end

  def render("show.json", %{skill: skill}) do
    %{data: render_one(skill, SkillView, "skill.json")}
  end

  def render("skill.json", %{skill: skill}) do
    %{id: skill.id,
      name: skill.name,
      desc: skill.desc,
      level_req: skill.level_req,
      type: skill.type,
      sp_cost: skill.sp_cost,
      dice: skill.dice,
      dice_bonus: skill.dice_bonus,
      target: skill.target}
  end
end
