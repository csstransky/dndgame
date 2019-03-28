defmodule Dndgame.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :desc, :text
      add :hit_dice, :string

      timestamps()
    end

  end
end
