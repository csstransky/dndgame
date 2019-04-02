defmodule Dndgame.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :desc, :text
      add :level_req, :integer
      add :sp_cost, :integer
      add :type, :string
      add :dice, :string
      add :dice_bonus, :integer
      add :target, :string
      add :buff_stat, :string

      timestamps()
    end

  end
end
