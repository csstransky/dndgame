defmodule Dndgame.Monsters.Attacks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monster_has_attacks" do
    field :monster_id, :id
    field :attack_id, :id

    timestamps()
  end

  @doc false
  def changeset(attacks, attrs) do
    attacks
    |> cast(attrs, [])
    |> validate_required([])
  end
end
