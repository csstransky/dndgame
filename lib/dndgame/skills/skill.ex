defmodule Dndgame.Skills.Skill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skills" do
    field :desc, :string
    field :dice, :string
    field :dice_bonus, :integer
    field :level_req, :integer
    field :name, :string
    field :sp_cost, :integer
    field :target, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:name, :desc, :level_req, :type, :sp_cost, :dice, :dice_bonus, :target])
    |> validate_required([:name, :desc, :level_req, :type, :sp_cost, :dice, :dice_bonus, :target])
  end
end