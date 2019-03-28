defmodule Dndgame.Attacks.Attack do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attacks" do
    field :attack_bonus, :integer
    field :damage_bonus, :integer
    field :damage_dice, :string
    field :desc, :string
    field :name, :string
    field :target, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(attack, attrs) do
    attack
    |> cast(attrs, [:name, :desc, :attack_bonus, :type, :damage_dice, :damage_bonus, :target])
    |> validate_required([:name, :desc, :attack_bonus, :type, :damage_dice, :damage_bonus, :target])
  end
end
