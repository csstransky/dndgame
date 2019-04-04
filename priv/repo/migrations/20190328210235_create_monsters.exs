defmodule Dndgame.Repo.Migrations.CreateMonsters do
  use Ecto.Migration

  def change do
    create table(:monsters) do
      add :name, :string
      add :desc, :text
      add :hp, :integer
      add :ac, :integer
      add :type, :string
      add :element, :string
      add :str, :integer
      add :dex, :integer
      add :int, :integer
      add :con, :integer
      add :cha, :integer
      add :wis, :integer
      add :size, :integer

      timestamps()
    end

  end
end
