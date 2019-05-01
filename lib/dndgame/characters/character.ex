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
    attrs = fix_zero_stats(attrs)
    character
    |> cast(attrs, [:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
    |> validate_required([:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
    |> validate_armor()
  end

  def fix_zero_stats(attrs) do
    if Map.get(attrs, "str") == "0" do
      attrs
      |> Map.put("str", "10")
      |> Map.put("dex", "10")
      |> Map.put("int", "10")
      |> Map.put("con", "10")
      |> Map.put("wis", "10")
      |> Map.put("cha", "10")
    else
      attrs
    end
  end

  def validate_armor(changeset) do
    validate_change(changeset, :armor_id, fn _, armor_id ->
      str = changeset.changes.str
      armor = Dndgame.Armors.get_armor!(armor_id)
      if armor.str_minimum > str do
        [{:armor_id, "not enough STR for armor"}]
      else
        []
      end
    end)
  end
end
