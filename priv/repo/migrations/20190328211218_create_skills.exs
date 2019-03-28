defmodule Dndgame.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :name, :string
      add :desc, :text
      add :level_req, :integer
      add :type, :string
      add :sp_cost, :integer
      add :dice, :string
      add :dice_bonus, :integer
      add :target, :string

      timestamps()
    end

  end
end
