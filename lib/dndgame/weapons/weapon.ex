defmodule Dndgame.Weapons.Weapon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weapons" do
    field :desc, :string, default: ""
    field :name, :string
    field :weapon_category, :string
    belongs_to :attack, Dndgame.Attacks.Attack

    timestamps()
  end

  @doc false
  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, [:name, :desc, :weapon_category, :attack_id])
    |> foreign_key_constraint(:attack)
    |> validate_required([:name, :desc, :weapon_category, :attack_id])
  end
end
