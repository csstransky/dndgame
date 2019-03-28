defmodule Dndgame.Repo.Migrations.CreateMonsterHasAttacks do
  use Ecto.Migration

  def change do
    create table(:monster_has_attacks) do
      add :monster_id, references(:monsters, on_delete: :nothing)
      add :attack_id, references(:attacks, on_delete: :nothing)

      timestamps()
    end

    create index(:monster_has_attacks, [:monster_id])
    create index(:monster_has_attacks, [:attack_id])
  end
end
