defmodule Dndgame.RacesTest do
  use Dndgame.DataCase

  alias Dndgame.Races

  describe "races" do
    alias Dndgame.Races.Race

    @valid_attrs %{cha_bonus: 42, con_bonus: 42, desc: "some desc", dex_bonus: 42, int_bonus: 42, name: "some name", size: "some size", str_bonus: 42, wis_bonus: 42}
    @update_attrs %{cha_bonus: 43, con_bonus: 43, desc: "some updated desc", dex_bonus: 43, int_bonus: 43, name: "some updated name", size: "some updated size", str_bonus: 43, wis_bonus: 43}
    @invalid_attrs %{cha_bonus: nil, con_bonus: nil, desc: nil, dex_bonus: nil, int_bonus: nil, name: nil, size: nil, str_bonus: nil, wis_bonus: nil}

    def race_fixture(attrs \\ %{}) do
      {:ok, race} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Races.create_race()

      race
    end

    test "list_races/0 returns all races" do
      race = race_fixture()
      assert Races.list_races() == [race]
    end

    test "get_race!/1 returns the race with given id" do
      race = race_fixture()
      assert Races.get_race!(race.id) == race
    end

    test "create_race/1 with valid data creates a race" do
      assert {:ok, %Race{} = race} = Races.create_race(@valid_attrs)
      assert race.cha_bonus == 42
      assert race.con_bonus == 42
      assert race.desc == "some desc"
      assert race.dex_bonus == 42
      assert race.int_bonus == 42
      assert race.name == "some name"
      assert race.size == "some size"
      assert race.str_bonus == 42
      assert race.wis_bonus == 42
    end

    test "create_race/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Races.create_race(@invalid_attrs)
    end

    test "update_race/2 with valid data updates the race" do
      race = race_fixture()
      assert {:ok, %Race{} = race} = Races.update_race(race, @update_attrs)
      assert race.cha_bonus == 43
      assert race.con_bonus == 43
      assert race.desc == "some updated desc"
      assert race.dex_bonus == 43
      assert race.int_bonus == 43
      assert race.name == "some updated name"
      assert race.size == "some updated size"
      assert race.str_bonus == 43
      assert race.wis_bonus == 43
    end

    test "update_race/2 with invalid data returns error changeset" do
      race = race_fixture()
      assert {:error, %Ecto.Changeset{}} = Races.update_race(race, @invalid_attrs)
      assert race == Races.get_race!(race.id)
    end

    test "delete_race/1 deletes the race" do
      race = race_fixture()
      assert {:ok, %Race{}} = Races.delete_race(race)
      assert_raise Ecto.NoResultsError, fn -> Races.get_race!(race.id) end
    end

    test "change_race/1 returns a race changeset" do
      race = race_fixture()
      assert %Ecto.Changeset{} = Races.change_race(race)
    end
  end
end
