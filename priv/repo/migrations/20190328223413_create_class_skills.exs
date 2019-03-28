defmodule Dndgame.Repo.Migrations.CreateClassSkills do
  use Ecto.Migration

  def change do
    create table(:class_skills) do
      add :class_id, references(:classes, on_delete: :nothing)
      add :skill_id, references(:skills, on_delete: :nothing)

      timestamps()
    end

    create index(:class_skills, [:class_id])
    create index(:class_skills, [:skill_id])
  end
end
