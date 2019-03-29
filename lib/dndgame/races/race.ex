defmodule Dndgame.Races.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :cha_bonus, :integer
    field :con_bonus, :integer
    field :desc, :string, default: ""
    field :dex_bonus, :integer
    field :int_bonus, :integer
    field :name, :string
    field :size, :string
    field :str_bonus, :integer
    field :wis_bonus, :integer
    field :prof_array, {:array, :string}
    field :save_array, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :desc, :str_bonus, :dex_bonus, :con_bonus, :int_bonus, :wis_bonus, :cha_bonus, :size])
    |> validate_required([:name, :desc, :str_bonus, :dex_bonus, :con_bonus, :int_bonus, :wis_bonus, :cha_bonus, :size])
  end
end
