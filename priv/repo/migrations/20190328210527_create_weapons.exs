defmodule Dndgame.Repo.Migrations.CreateWeapons do
  use Ecto.Migration

  def change do
    create table(:weapons) do
      add :name, :string
      add :desc, :text
      add :weapon_category, :string
      add :attack, references(:attacks, on_delete: :nothing)

      timestamps()
    end

    create index(:weapons, [:attack])
  end
end
