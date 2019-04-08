defmodule Dndgame.Monsters.Monster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monsters" do
    field :ac, :integer
    field :desc, :string, default: ""
    field :hp, :integer
    field :name, :string
    field :type, :string
    field :element, :string
    field :str, :integer
    field :dex, :integer
    field :int, :integer
    field :con, :integer
    field :cha, :integer
    field :wis, :integer
    # Size = 0 is medium, size = -1 is small, size 1 is large, etc
    field :size, :integer, default: 0
    field :exp, :integer, default: 35
    many_to_many :attacks, Dndgame.Attacks.Attack, join_through: "monster_attacks"

    timestamps()
  end

  @doc false
  def changeset(monster, attrs) do
    monster
    |> cast(attrs, [:name, :desc, :hp, :prof_bonus, :initiative, :ac, :type])
    |> validate_required([:name, :desc, :hp, :prof_bonus, :initiative, :ac, :type])
  end
end
