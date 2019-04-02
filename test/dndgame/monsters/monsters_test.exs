defmodule Dndgame.MonstersTest do
  use Dndgame.DataCase

  alias Dndgame.Monsters

  describe "monsters" do
    alias Dndgame.Monsters.Monster

    @valid_attrs %{ac: 42, desc: "some desc", hp: 42, initiative: 42, mp: 42, name: "some name", prof_bonus: 42, sp: 42, type: "some type"}
    @update_attrs %{ac: 43, desc: "some updated desc", hp: 43, initiative: 43, mp: 43, name: "some updated name", prof_bonus: 43, sp: 43, type: "some updated type"}
    @invalid_attrs %{ac: nil, desc: nil, hp: nil, initiative: nil, mp: nil, name: nil, prof_bonus: nil, sp: nil, type: nil}

    def monster_fixture(attrs \\ %{}) do
      {:ok, monster} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monsters.create_monster()

      monster
    end

    test "list_monsters/0 returns all monsters" do
      monster = monster_fixture()
      assert Monsters.list_monsters() == [monster]
    end

    test "get_monster!/1 returns the monster with given id" do
      monster = monster_fixture()
      assert Monsters.get_monster!(monster.id) == monster
    end

    test "create_monster/1 with valid data creates a monster" do
      assert {:ok, %Monster{} = monster} = Monsters.create_monster(@valid_attrs)
      assert monster.ac == 42
      assert monster.desc == "some desc"
      assert monster.hp == 42
      assert monster.initiative == 42
      assert monster.mp == 42
      assert monster.name == "some name"
      assert monster.prof_bonus == 42
      assert monster.sp == 42
      assert monster.type == "some type"
    end

    test "create_monster/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monsters.create_monster(@invalid_attrs)
    end

    test "update_monster/2 with valid data updates the monster" do
      monster = monster_fixture()
      assert {:ok, %Monster{} = monster} = Monsters.update_monster(monster, @update_attrs)
      assert monster.ac == 43
      assert monster.desc == "some updated desc"
      assert monster.hp == 43
      assert monster.initiative == 43
      assert monster.mp == 43
      assert monster.name == "some updated name"
      assert monster.prof_bonus == 43
      assert monster.sp == 43
      assert monster.type == "some updated type"
    end

    test "update_monster/2 with invalid data returns error changeset" do
      monster = monster_fixture()
      assert {:error, %Ecto.Changeset{}} = Monsters.update_monster(monster, @invalid_attrs)
      assert monster == Monsters.get_monster!(monster.id)
    end

    test "delete_monster/1 deletes the monster" do
      monster = monster_fixture()
      assert {:ok, %Monster{}} = Monsters.delete_monster(monster)
      assert_raise Ecto.NoResultsError, fn -> Monsters.get_monster!(monster.id) end
    end

    test "change_monster/1 returns a monster changeset" do
      monster = monster_fixture()
      assert %Ecto.Changeset{} = Monsters.change_monster(monster)
    end
  end
end
