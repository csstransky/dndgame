defmodule Dndgame.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :cha, :integer
      add :con, :integer
      add :dex, :integer
      add :exp, :integer
      add :int, :integer
      add :name, :string
      add :str, :integer
      add :wis, :integer
      add :prof_bonus, :integer
      add :prof_array, {:array, :string}
      add :save_array, {:array, :string}
      add :weapon_prof_array, {:array, :string}
      add :armor_prof_array, {:array, :string}
      add :weapon_id, references(:weapons, on_delete: :nothing)
      add :armor_id, references(:armors, on_delete: :nothing)
      add :race_id, references(:races, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:characters, [:weapon_id])
    create index(:characters, [:armor_id])
    create index(:characters, [:race_id])
    create index(:characters, [:class_id])
    create index(:characters, [:user_id])
  end
end
