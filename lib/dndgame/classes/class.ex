defmodule Dndgame.Classes.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :desc, :string, default: ""
    field :hit_die, :integer
    field :name, :string
    field :prof_array, {:array, :string}
    field :save_array, {:array, :string}
    field :weapon_prof_array, {:array, :string}
    field :armor_prof_array, {:array, :string}, default: []
    field :ability_modifier, :string
    many_to_many :skills, Dndgame.Skills.Skill, join_through: "class_skills"
    many_to_many :spells, Dndgame.Spells.Spell, join_through: "class_spells"
    has_many :characters, Dndgame.Characters.Character

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :desc, :hit_die])
    |> validate_required([:name, :desc, :hit_die, :ability_modifier])
  end
end
