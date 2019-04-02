defmodule Dndgame.Repo.Migrations.CreateMonsters do
  use Ecto.Migration

  def change do
    create table(:monsters) do
      add :name, :string
      add :desc, :text
      add :hp, :integer
      add :initiative, :integer
      add :ac, :integer
      add :mp, :integer
      add :sp, :integer
      add :type, :string

      timestamps()
    end

  end
end
