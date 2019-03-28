defmodule Dndgame.Spells.Spell do
  use Ecto.Schema
  import Ecto.Changeset

  schema "spells" do
    field :desc, :string
    field :dice, :string
    field :dice_bonus, :integer
    field :level_req, :integer
    field :mp_cost, :integer
    field :name, :string
    field :target, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(spell, attrs) do
    spell
    |> cast(attrs, [:name, :desc, :level_req, :type, :mp_cost, :dice, :dice_bonus, :target])
    |> validate_required([:name, :desc, :level_req, :type, :mp_cost, :dice, :dice_bonus, :target])
  end
end
