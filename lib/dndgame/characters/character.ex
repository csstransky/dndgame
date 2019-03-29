defmodule Dndgame.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :ac, :integer
    field :cha, :integer
    field :con, :integer
    field :dex, :integer
    field :exp, :integer, default: 0
    field :hp, :integer
    field :initiative, :integer
    field :int, :integer
    field :level, :integer, default: 1
    field :mp, :integer
    field :name, :string
    field :sp, :integer
    field :str, :integer
    field :wis, :integer
    field :weapon, :id
    field :armor, :id
    field :race, :id
    field :class, :id
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :str, :dex, :con, :int, :wis, :cha, :initiative, :hp, :ac, :mp, :sp, :level, :exp])
    |> validate_required([:name, :str, :dex, :con, :int, :wis, :cha, :initiative, :hp, :ac, :mp, :sp, :level, :exp])
  end
end
