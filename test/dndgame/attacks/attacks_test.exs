defmodule Dndgame.AttacksTest do
  use Dndgame.DataCase

  alias Dndgame.Attacks

  describe "attacks" do
    alias Dndgame.Attacks.Attack

    @valid_attrs %{attack_bonus: 42, damage_bonus: 42, damage_dice: "some damage_dice", desc: "some desc", name: "some name", target: "some target", type: "some type"}
    @update_attrs %{attack_bonus: 43, damage_bonus: 43, damage_dice: "some updated damage_dice", desc: "some updated desc", name: "some updated name", target: "some updated target", type: "some updated type"}
    @invalid_attrs %{attack_bonus: nil, damage_bonus: nil, damage_dice: nil, desc: nil, name: nil, target: nil, type: nil}

    def attack_fixture(attrs \\ %{}) do
      {:ok, attack} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Attacks.create_attack()

      attack
    end

    test "list_attacks/0 returns all attacks" do
      attack = attack_fixture()
      assert Attacks.list_attacks() == [attack]
    end

    test "get_attack!/1 returns the attack with given id" do
      attack = attack_fixture()
      assert Attacks.get_attack!(attack.id) == attack
    end

    test "create_attack/1 with valid data creates a attack" do
      assert {:ok, %Attack{} = attack} = Attacks.create_attack(@valid_attrs)
      assert attack.attack_bonus == 42
      assert attack.damage_bonus == 42
      assert attack.damage_dice == "some damage_dice"
      assert attack.desc == "some desc"
      assert attack.name == "some name"
      assert attack.target == "some target"
      assert attack.type == "some type"
    end

    test "create_attack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Attacks.create_attack(@invalid_attrs)
    end

    test "update_attack/2 with valid data updates the attack" do
      attack = attack_fixture()
      assert {:ok, %Attack{} = attack} = Attacks.update_attack(attack, @update_attrs)
      assert attack.attack_bonus == 43
      assert attack.damage_bonus == 43
      assert attack.damage_dice == "some updated damage_dice"
      assert attack.desc == "some updated desc"
      assert attack.name == "some updated name"
      assert attack.target == "some updated target"
      assert attack.type == "some updated type"
    end

    test "update_attack/2 with invalid data returns error changeset" do
      attack = attack_fixture()
      assert {:error, %Ecto.Changeset{}} = Attacks.update_attack(attack, @invalid_attrs)
      assert attack == Attacks.get_attack!(attack.id)
    end

    test "delete_attack/1 deletes the attack" do
      attack = attack_fixture()
      assert {:ok, %Attack{}} = Attacks.delete_attack(attack)
      assert_raise Ecto.NoResultsError, fn -> Attacks.get_attack!(attack.id) end
    end

    test "change_attack/1 returns a attack changeset" do
      attack = attack_fixture()
      assert %Ecto.Changeset{} = Attacks.change_attack(attack)
    end
  end
end
