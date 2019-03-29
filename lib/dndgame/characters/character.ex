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
    field :prof_bonus, :integer
    field :prof_array, {:array, :string}
    field :save_array, {:array, :string}
    field :weapon_prof_array, {:array, :string}
    field :armor_prof_array, {:array, :string}
    has_one :weapon, Dndgame.Weapons.Weapon
    has_one :armor, Dndgame.Armors.Armor
    has_one :race, Dndgame.Races.Race
    has_one :class, Dndgame.Classes.Class
    belongs_to :user, Dndgame.Users.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:ac, :cha, :con, :dex, :exp, :hp, :initiative, :int, :level, :mp, :name, :sp, :str, :wis, :prof_bonus])
    |> validate_required([:ac, :cha, :con, :dex, :exp, :hp, :initiative, :int, :level, :mp, :name, :sp, :str, :wis])
  end
end
