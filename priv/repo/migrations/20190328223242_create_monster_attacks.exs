defmodule Dndgame.Repo.Migrations.CreateMonsterAttacks do
  use Ecto.Migration

  def change do
    create table(:monster_attacks) do
      add :monster_id, references(:monsters, on_delete: :nothing)
      add :attack_id, references(:attacks, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:monster_attacks, [:monster_id, :attack_id])
  end
end
