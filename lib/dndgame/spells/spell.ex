defmodule Dndgame.Spells.Spell do
  use Ecto.Schema
  import Ecto.Changeset

  schema "spells" do
    field :desc, :string, default: ""
    field :dice, :string
    field :dice_bonus, :integer
    field :level_req, :integer
    field :name, :string
    field :target, :string
    field :type, :string
    many_to_many :classes, Dndgame.Classes.Class, join_through: "class_spells"

    timestamps()
  end

  @doc false
  def changeset(spell, attrs) do
    spell
    |> cast(attrs, [:name, :desc, :level_req, :type, :mp_cost, :dice, :dice_bonus, :target])
    |> validate_required([:name, :desc, :level_req, :type, :mp_cost, :dice, :dice_bonus, :target])
  end
end
