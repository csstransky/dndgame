defmodule Dndgame.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :ac, :integer
    field :cha, :integer
    field :con, :integer
    field :dex, :integer
    field :exp, :integer
    field :hp, :integer
    field :initiative, :integer
    field :int, :integer
    field :level, :integer
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
    |> cast(attrs, [:ac, :cha, :con, :dex, :exp, :hp, :initiative, :int, :level, :mp, :name, :sp, :str, :wis])
    |> validate_required([:ac, :cha, :con, :dex, :exp, :hp, :initiative, :int, :level, :mp, :name, :sp, :str, :wis])
  end
end
