defmodule Dndgame.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :desc, :text
      add :hit_dice, :string
      add :prof_array, {:array, :string}
      add :save_array, {:array, :string}

      timestamps()
    end
  end
end
