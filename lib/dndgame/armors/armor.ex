defmodule Dndgame.Armors.Armor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "armors" do
    field :armor_category, :string
    field :base, :integer
    field :desc, :string, default: ""
    field :dex_bonus, :boolean, default: false
    field :name, :string
    field :stealth_disadvantage, :boolean, default: false
    field :str_minimum, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(armor, attrs) do
    armor
    |> cast(attrs, [:name, :desc, :armor_category, :base, :dex_bonus, :str_minimum, :stealth_disadvantage])
    |> validate_required([:name, :desc, :armor_category, :base, :dex_bonus, :str_minimum, :stealth_disadvantage])
  end
end
