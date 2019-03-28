defmodule Dndgame.Classes.Spells do
  use Ecto.Schema
  import Ecto.Changeset

  schema "class_spells" do
    field :class_id, :id
    field :spell_id, :id

    timestamps()
  end

  @doc false
  def changeset(spells, attrs) do
    spells
    |> cast(attrs, [])
    |> validate_required([])
  end
end
