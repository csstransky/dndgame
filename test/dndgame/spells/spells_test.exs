defmodule Dndgame.SpellsTest do
  use Dndgame.DataCase

  alias Dndgame.Spells

  describe "spells" do
    alias Dndgame.Spells.Spell

    @valid_attrs %{desc: "some desc", dice: "some dice", dice_bonus: 42, level_req: 42, mp_cost: 42, name: "some name", target: "some target", type: "some type"}
    @update_attrs %{desc: "some updated desc", dice: "some updated dice", dice_bonus: 43, level_req: 43, mp_cost: 43, name: "some updated name", target: "some updated target", type: "some updated type"}
    @invalid_attrs %{desc: nil, dice: nil, dice_bonus: nil, level_req: nil, mp_cost: nil, name: nil, target: nil, type: nil}

    def spell_fixture(attrs \\ %{}) do
      {:ok, spell} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Spells.create_spell()

      spell
    end

    test "list_spells/0 returns all spells" do
      spell = spell_fixture()
      assert Spells.list_spells() == [spell]
    end

    test "get_spell!/1 returns the spell with given id" do
      spell = spell_fixture()
      assert Spells.get_spell!(spell.id) == spell
    end

    test "create_spell/1 with valid data creates a spell" do
      assert {:ok, %Spell{} = spell} = Spells.create_spell(@valid_attrs)
      assert spell.desc == "some desc"
      assert spell.dice == "some dice"
      assert spell.dice_bonus == 42
      assert spell.level_req == 42
      assert spell.mp_cost == 42
      assert spell.name == "some name"
      assert spell.target == "some target"
      assert spell.type == "some type"
    end

    test "create_spell/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spells.create_spell(@invalid_attrs)
    end

    test "update_spell/2 with valid data updates the spell" do
      spell = spell_fixture()
      assert {:ok, %Spell{} = spell} = Spells.update_spell(spell, @update_attrs)
      assert spell.desc == "some updated desc"
      assert spell.dice == "some updated dice"
      assert spell.dice_bonus == 43
      assert spell.level_req == 43
      assert spell.mp_cost == 43
      assert spell.name == "some updated name"
      assert spell.target == "some updated target"
      assert spell.type == "some updated type"
    end

    test "update_spell/2 with invalid data returns error changeset" do
      spell = spell_fixture()
      assert {:error, %Ecto.Changeset{}} = Spells.update_spell(spell, @invalid_attrs)
      assert spell == Spells.get_spell!(spell.id)
    end

    test "delete_spell/1 deletes the spell" do
      spell = spell_fixture()
      assert {:ok, %Spell{}} = Spells.delete_spell(spell)
      assert_raise Ecto.NoResultsError, fn -> Spells.get_spell!(spell.id) end
    end

    test "change_spell/1 returns a spell changeset" do
      spell = spell_fixture()
      assert %Ecto.Changeset{} = Spells.change_spell(spell)
    end
  end
end
