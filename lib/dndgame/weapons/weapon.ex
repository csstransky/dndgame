defmodule Dndgame.Weapons.Weapon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weapons" do
    field :desc, :string
    field :name, :string
    field :weapon_category, :string
    field :attack, :id

    timestamps()
  end

  @doc false
  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, [:name, :desc, :weapon_category])
    |> foreign_key_constraint(:attack)
    |> validate_required([:name, :desc, :weapon_category])
  end
end
