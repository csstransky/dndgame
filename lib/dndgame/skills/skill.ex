defmodule Dndgame.Skills.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skills" do
    field :desc, :string, default: ""
    field :dice, :string
    field :dice_bonus, :integer, default: 0
    field :level_req, :integer
    field :name, :string
    field :sp_cost, :integer
    field :target, :string
    field :type, :string
    field :buff_stat, :string, default: "none"
    many_to_many :classes, Dndgame.Classes.Class, join_through: "class_skills"

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :desc, :level_req, :type, :sp_cost, :dice, :dice_bonus, :target])
    |> validate_required([:name, :desc, :level_req, :type, :sp_cost, :dice, :dice_bonus, :target])
  end
end
