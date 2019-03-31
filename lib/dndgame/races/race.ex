defmodule Dndgame.Races.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :cha_bonus, :integer, default: 0
    field :con_bonus, :integer, default: 0
    field :desc, :string, default: ""
    field :dex_bonus, :integer, default: 0
    field :int_bonus, :integer, default: 0
    field :name, :string
    # Size = 0 is medium, size = -1 is small, size 1 is large, etc
    field :size, :integer, default: 0
    field :str_bonus, :integer, default: 0
    field :wis_bonus, :integer, default: 0
    field :prof_array, {:array, :string}, default: []
    field :save_array, {:array, :string}, default: []
    field :weapon_prof_array, {:array, :string}, default: []
    field :armor_prof_array, {:array, :string}, default: []


    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :desc, :str_bonus, :dex_bonus, :con_bonus, :int_bonus, :wis_bonus, :cha_bonus, :size])
    |> validate_required([:name, :desc, :str_bonus, :dex_bonus, :con_bonus, :int_bonus, :wis_bonus, :cha_bonus, :size])
  end
end
