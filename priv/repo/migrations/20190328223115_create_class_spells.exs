defmodule Dndgame.Repo.Migrations.CreateClassSpells do
  use Ecto.Migration

  def change do
    create table(:class_spells) do
      add :class_id, references(:classes, on_delete: :nothing)
      add :spell_id, references(:spells, on_delete: :nothing)

      timestamps()
    end

    create index(:class_spells, [:class_id])
    create index(:class_spells, [:spell_id])
  end
end
