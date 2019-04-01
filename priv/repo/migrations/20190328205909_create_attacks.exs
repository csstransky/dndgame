defmodule Dndgame.Repo.Migrations.CreateAttacks do
  use Ecto.Migration

  def change do
    create table(:attacks) do
      add :name, :string
      add :desc, :text
      add :attack_bonus, :integer
      add :type, :string
      add :damage_dice, :string
      add :damage_bonus, :integer
      add :target, :string

      timestamps()
    end

  end
end
