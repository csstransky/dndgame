defmodule Dndgame.CharactersTest do
  use Dndgame.DataCase

  alias Dndgame.Characters

  describe "characters" do
    alias Dndgame.Characters.Character

    @valid_attrs %{ac: 42, cha: 42, con: 42, dex: 42, exp: 42, hp: 42, initiative: 42, int: 42, level: 42, mp: 42, name: "some name", sp: 42, str: 42, wis: 42}
    @update_attrs %{ac: 43, cha: 43, con: 43, dex: 43, exp: 43, hp: 43, initiative: 43, int: 43, level: 43, mp: 43, name: "some updated name", sp: 43, str: 43, wis: 43}
    @invalid_attrs %{ac: nil, cha: nil, con: nil, dex: nil, exp: nil, hp: nil, initiative: nil, int: nil, level: nil, mp: nil, name: nil, sp: nil, str: nil, wis: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Characters.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Characters.create_character(@valid_attrs)
      assert character.ac == 42
      assert character.cha == 42
      assert character.con == 42
      assert character.dex == 42
      assert character.exp == 42
      assert character.hp == 42
      assert character.initiative == 42
      assert character.int == 42
      assert character.level == 42
      assert character.mp == 42
      assert character.name == "some name"
      assert character.sp == 42
      assert character.str == 42
      assert character.wis == 42
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, %Character{} = character} = Characters.update_character(character, @update_attrs)
      assert character.ac == 43
      assert character.cha == 43
      assert character.con == 43
      assert character.dex == 43
      assert character.exp == 43
      assert character.hp == 43
      assert character.initiative == 43
      assert character.int == 43
      assert character.level == 43
      assert character.mp == 43
      assert character.name == "some updated name"
      assert character.sp == 43
      assert character.str == 43
      assert character.wis == 43
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_character(character, @invalid_attrs)
      assert character == Characters.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Characters.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Characters.change_character(character)
    end
  end

  describe "characters" do
    alias Dndgame.Characters.Character

    @valid_attrs %{ac: 42, cha: 42, con: 42, dex: 42, exp: 42, hp: 42, iniatiative: 42, int: 42, level: 42, mp: 42, name: "some name", sp: 42, str: 42, wis: 42}
    @update_attrs %{ac: 43, cha: 43, con: 43, dex: 43, exp: 43, hp: 43, iniatiative: 43, int: 43, level: 43, mp: 43, name: "some updated name", sp: 43, str: 43, wis: 43}
    @invalid_attrs %{ac: nil, cha: nil, con: nil, dex: nil, exp: nil, hp: nil, iniatiative: nil, int: nil, level: nil, mp: nil, name: nil, sp: nil, str: nil, wis: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Characters.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Characters.create_character(@valid_attrs)
      assert character.ac == 42
      assert character.cha == 42
      assert character.con == 42
      assert character.dex == 42
      assert character.exp == 42
      assert character.hp == 42
      assert character.iniatiative == 42
      assert character.int == 42
      assert character.level == 42
      assert character.mp == 42
      assert character.name == "some name"
      assert character.sp == 42
      assert character.str == 42
      assert character.wis == 42
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, %Character{} = character} = Characters.update_character(character, @update_attrs)
      assert character.ac == 43
      assert character.cha == 43
      assert character.con == 43
      assert character.dex == 43
      assert character.exp == 43
      assert character.hp == 43
      assert character.iniatiative == 43
      assert character.int == 43
      assert character.level == 43
      assert character.mp == 43
      assert character.name == "some updated name"
      assert character.sp == 43
      assert character.str == 43
      assert character.wis == 43
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_character(character, @invalid_attrs)
      assert character == Characters.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Characters.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Characters.change_character(character)
    end
  end
end
