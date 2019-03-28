defmodule Dndgame.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :ac, :integer
      add :cha, :integer
      add :con, :integer
      add :dex, :integer
      add :exp, :integer
      add :hp, :integer
      add :initiative, :integer
      add :int, :integer
      add :level, :integer
      add :mp, :integer
      add :name, :string
      add :sp, :integer
      add :str, :integer
      add :wis, :integer
      add :weapon, references(:weapons, on_delete: :nothing)
      add :armor, references(:armors, on_delete: :nothing)
      add :race, references(:races, on_delete: :nothing)
      add :class, references(:classes, on_delete: :nothing)
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:characters, [:weapon])
    create index(:characters, [:armor])
    create index(:characters, [:race])
    create index(:characters, [:class])
    create index(:characters, [:user])
  end
end
