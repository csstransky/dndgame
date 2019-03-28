defmodule Dndgame.Repo.Migrations.CreateArmors do
  use Ecto.Migration

  def change do
    create table(:armors) do
      add :name, :string
      add :desc, :text
      add :armor_category, :string
      add :base, :integer
      add :dex_bonus, :boolean, default: false, null: false
      add :str_minimum, :integer
      add :stealth_disadvantage, :boolean, default: false, null: false

      timestamps()
    end

  end
end
