defmodule Dndgame.Monsters.Attacks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monster_attacks" do
    belongs_to :monster, Dndgame.Monsters.Monster
    belongs_to :attack, Dndgame.Attacks.Attack

    timestamps()
  end

  @doc false
  def changeset(attacks, attrs) do
    attacks
    |> cast(attrs, [])
    |> validate_required([])
  end
end
