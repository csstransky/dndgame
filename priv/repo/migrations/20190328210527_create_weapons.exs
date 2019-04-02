defmodule Dndgame.Repo.Migrations.CreateWeapons do
  use Ecto.Migration

  def change do
    create table(:weapons) do
      add :name, :string
      add :desc, :text
      add :weapon_category, :string
      add :attack_id, references(:attacks)

      timestamps()
    end
    create index(:weapons, [:attack_id])
  end
end
