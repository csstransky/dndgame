defmodule Dndgame.Monsters.Monster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monsters" do
    field :ac, :integer
    field :desc, :string
    field :hp, :integer
    field :initiative, :integer
    field :mp, :integer
    field :name, :string
    field :sp, :integer
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(monster, attrs) do
    monster
    |> cast(attrs, [:name, :desc, :hp, :prof_bonus, :initiative, :ac, :mp, :sp, :type])
    |> validate_required([:name, :desc, :hp, :prof_bonus, :initiative, :ac, :mp, :sp, :type])
  end
end
