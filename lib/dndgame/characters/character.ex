defmodule Dndgame.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :cha, :integer
    field :con, :integer
    field :dex, :integer
    field :exp, :integer, default: 0
    field :int, :integer
    field :name, :string
    field :str, :integer
    field :wis, :integer
    belongs_to :weapon, Dndgame.Weapons.Weapon
    belongs_to :armor, Dndgame.Armors.Armor
    belongs_to :race, Dndgame.Races.Race
    belongs_to :class, Dndgame.Classes.Class
    belongs_to :user, Dndgame.Users.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    IO.inspect("CAN YOU SEE ME")
    IO.inspect(attrs)
    character
    |> cast(attrs, [:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
    |> validate_required([:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
  end
end
