defmodule Dndgame.Classes.Skills do
  use Ecto.Schema
  import Ecto.Changeset

  schema "class_skills" do
    belongs_to :class, Dndgame.Classes.Class
    belongs_to :skill, Dndgame.Skills.Skill

    timestamps()
  end

  @doc false
  def changeset(skills, attrs) do
    skills
    |> cast(attrs, [])
    |> validate_required([])
  end
end
