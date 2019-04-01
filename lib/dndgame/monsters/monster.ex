defmodule Dndgame.Monsters.Monster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monsters" do
    field :ac, :integer
    field :desc, :string, default: ""
    field :hp, :integer
    field :initiative, :integer
    field :mp, :integer
    field :name, :string
    field :sp, :integer
    field :type, :string
    many_to_many :attacks, Dndgame.Attacks.Attack, join_through: "monster_attacks"

    timestamps()
  end

  @doc false
  def changeset(monster, attrs) do
    monster
    |> cast(attrs, [:name, :desc, :hp, :prof_bonus, :initiative, :ac, :mp, :sp, :type])
    |> validate_required([:name, :desc, :hp, :prof_bonus, :initiative, :ac, :mp, :sp, :type])
  end
end
