defmodule Dndgame.Repo.Migrations.CreateRaces do
  use Ecto.Migration

  def change do
    create table(:races) do
      add :name, :string
      add :desc, :text
      add :str_bonus, :integer
      add :dex_bonus, :integer
      add :con_bonus, :integer
      add :int_bonus, :integer
      add :wis_bonus, :integer
      add :cha_bonus, :integer
      add :size, :string
      add :prof_array, {:array, :string}
      add :save_array, {:array, :string}

      timestamps()
    end
  end
end
