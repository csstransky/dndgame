defmodule Dndgame.Classes.Skills do
  use Ecto.Schema
  import Ecto.Changeset

  schema "class_skills" do
    field :class_id, :id
    field :skill_id, :id

    timestamps()
  end

  @doc false
  def changeset(skills, attrs) do
    skills
    |> cast(attrs, [])
    |> validate_required([])
  end
end
