defmodule Dndgame.ArmorsTest do
  use Dndgame.DataCase

  alias Dndgame.Armors

  describe "armors" do
    alias Dndgame.Armors.Armor

    @valid_attrs %{armor_category: "some armor_category", base: 42, desc: "some desc", dex_bonus: true, name: "some name", stealth_disadvantage: true, str_minimum: 42}
    @update_attrs %{armor_category: "some updated armor_category", base: 43, desc: "some updated desc", dex_bonus: false, name: "some updated name", stealth_disadvantage: false, str_minimum: 43}
    @invalid_attrs %{armor_category: nil, base: nil, desc: nil, dex_bonus: nil, name: nil, stealth_disadvantage: nil, str_minimum: nil}

    def armor_fixture(attrs \\ %{}) do
      {:ok, armor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Armors.create_armor()

      armor
    end

    test "list_armors/0 returns all armors" do
      armor = armor_fixture()
      assert Armors.list_armors() == [armor]
    end

    test "get_armor!/1 returns the armor with given id" do
      armor = armor_fixture()
      assert Armors.get_armor!(armor.id) == armor
    end

    test "create_armor/1 with valid data creates a armor" do
      assert {:ok, %Armor{} = armor} = Armors.create_armor(@valid_attrs)
      assert armor.armor_category == "some armor_category"
      assert armor.base == 42
      assert armor.desc == "some desc"
      assert armor.dex_bonus == true
      assert armor.name == "some name"
      assert armor.stealth_disadvantage == true
      assert armor.str_minimum == 42
    end

    test "create_armor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Armors.create_armor(@invalid_attrs)
    end

    test "update_armor/2 with valid data updates the armor" do
      armor = armor_fixture()
      assert {:ok, %Armor{} = armor} = Armors.update_armor(armor, @update_attrs)
      assert armor.armor_category == "some updated armor_category"
      assert armor.base == 43
      assert armor.desc == "some updated desc"
      assert armor.dex_bonus == false
      assert armor.name == "some updated name"
      assert armor.stealth_disadvantage == false
      assert armor.str_minimum == 43
    end

    test "update_armor/2 with invalid data returns error changeset" do
      armor = armor_fixture()
      assert {:error, %Ecto.Changeset{}} = Armors.update_armor(armor, @invalid_attrs)
      assert armor == Armors.get_armor!(armor.id)
    end

    test "delete_armor/1 deletes the armor" do
      armor = armor_fixture()
      assert {:ok, %Armor{}} = Armors.delete_armor(armor)
      assert_raise Ecto.NoResultsError, fn -> Armors.get_armor!(armor.id) end
    end

    test "change_armor/1 returns a armor changeset" do
      armor = armor_fixture()
      assert %Ecto.Changeset{} = Armors.change_armor(armor)
    end
  end
end
