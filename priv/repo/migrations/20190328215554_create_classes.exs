defmodule Dndgame.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :desc, :text
      add :hit_die, :integer
      add :prof_array, {:array, :string}
      add :save_array, {:array, :string}
      add :weapon_prof_array, {:array, :string}
      add :armor_prof_array, {:array, :string}
      add :ability_modifier, :string

      timestamps()
    end
  end
end
