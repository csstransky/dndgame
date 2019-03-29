defmodule Dndgame.Repo.Migrations.CreateClassSpells do
  use Ecto.Migration

  def change do
    create table(:class_spells) do
      add :class_id, references(:classes)
      add :spell_id, references(:spells)

      timestamps()
    end

    create unique_index(:class_spells, [:class_id, :spell_id])
  end
end
