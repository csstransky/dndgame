defmodule Dndgame.Classes.Spells do
  use Ecto.Schema
  import Ecto.Changeset

  schema "class_spells" do
    belongs_to :class, Dndgame.Classes.Class
    belongs_to :spell, Dndgame.Spells.Spell

    timestamps()
  end

  @doc false
  def changeset(spells, attrs) do
    spells
    |> cast(attrs, [])
    |> validate_required([])
  end
end
