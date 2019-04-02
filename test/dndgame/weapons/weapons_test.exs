defmodule Dndgame.WeaponsTest do
  use Dndgame.DataCase

  alias Dndgame.Weapons

  describe "weapons" do
    alias Dndgame.Weapons.Weapon

    @valid_attrs %{desc: "some desc", name: "some name", weapon_category: "some weapon_category"}
    @update_attrs %{desc: "some updated desc", name: "some updated name", weapon_category: "some updated weapon_category"}
    @invalid_attrs %{desc: nil, name: nil, weapon_category: nil}

    def weapon_fixture(attrs \\ %{}) do
      {:ok, weapon} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Weapons.create_weapon()

      weapon
    end

    test "list_weapons/0 returns all weapons" do
      weapon = weapon_fixture()
      assert Weapons.list_weapons() == [weapon]
    end

    test "get_weapon!/1 returns the weapon with given id" do
      weapon = weapon_fixture()
      assert Weapons.get_weapon!(weapon.id) == weapon
    end

    test "create_weapon/1 with valid data creates a weapon" do
      assert {:ok, %Weapon{} = weapon} = Weapons.create_weapon(@valid_attrs)
      assert weapon.desc == "some desc"
      assert weapon.name == "some name"
      assert weapon.weapon_category == "some weapon_category"
    end

    test "create_weapon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Weapons.create_weapon(@invalid_attrs)
    end

    test "update_weapon/2 with valid data updates the weapon" do
      weapon = weapon_fixture()
      assert {:ok, %Weapon{} = weapon} = Weapons.update_weapon(weapon, @update_attrs)
      assert weapon.desc == "some updated desc"
      assert weapon.name == "some updated name"
      assert weapon.weapon_category == "some updated weapon_category"
    end

    test "update_weapon/2 with invalid data returns error changeset" do
      weapon = weapon_fixture()
      assert {:error, %Ecto.Changeset{}} = Weapons.update_weapon(weapon, @invalid_attrs)
      assert weapon == Weapons.get_weapon!(weapon.id)
    end

    test "delete_weapon/1 deletes the weapon" do
      weapon = weapon_fixture()
      assert {:ok, %Weapon{}} = Weapons.delete_weapon(weapon)
      assert_raise Ecto.NoResultsError, fn -> Weapons.get_weapon!(weapon.id) end
    end

    test "change_weapon/1 returns a weapon changeset" do
      weapon = weapon_fixture()
      assert %Ecto.Changeset{} = Weapons.change_weapon(weapon)
    end
  end
end
