defmodule Dndgame.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dndgame.Characters

  schema "characters" do
    #TODO: make functions for all the commented out stuff
    #field :ac, :integer
    field :cha, :integer
    field :con, :integer
    field :dex, :integer
    field :exp, :integer
    #field :hp, :integer
    #field :initiative, :integer
    field :int, :integer
    #field :level, :integer
    #field :mp, :integer
    field :name, :string
    #field :sp, :integer
    field :str, :integer
    field :wis, :integer
    #field :prof_bonus, :integer
    #field :prof_array, {:array, :string}
    #field :save_array, {:array, :string}
    #field :weapon_prof_array, {:array, :string}
    #field :armor_prof_array, {:array, :string}
    belongs_to :weapon, Dndgame.Weapons.Weapon
    belongs_to :armor, Dndgame.Armors.Armor
    belongs_to :race, Dndgame.Races.Race
    belongs_to :class, Dndgame.Classes.Class
    belongs_to :user, Dndgame.Users.User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
    |> validate_required([:cha, :con, :dex, :exp, :int, :name, :str, :wis, :class_id, :armor_id, :weapon_id, :race_id, :user_id])
  end
end
