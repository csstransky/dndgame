defmodule Dndgame.Classes.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :desc, :string
    field :hit_dice, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :desc, :hit_dice])
    |> validate_required([:name, :desc, :hit_dice])
  end
end
