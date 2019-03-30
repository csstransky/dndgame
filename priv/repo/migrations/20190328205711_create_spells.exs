defmodule Dndgame.Repo.Migrations.CreateSpells do
  use Ecto.Migration

  def change do
    create table(:spells) do
      add :name, :string
      add :desc, :text
      add :level_req, :integer
      add :mp_cost, :integer
      add :type, :string
      add :dice, :string
      add :dice_bonus, :integer
      add :target, :string
      add :buff_stat, :string

      timestamps()
    end

  end
end
