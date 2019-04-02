defmodule DndgameWeb.RaceControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Races
  alias Dndgame.Races.Race

  @create_attrs %{
    cha_bonus: 42,
    con_bonus: 42,
    desc: "some desc",
    dex_bonus: 42,
    int_bonus: 42,
    name: "some name",
    size: "some size",
    str_bonus: 42,
    wis_bonus: 42
  }
  @update_attrs %{
    cha_bonus: 43,
    con_bonus: 43,
    desc: "some updated desc",
    dex_bonus: 43,
    int_bonus: 43,
    name: "some updated name",
    size: "some updated size",
    str_bonus: 43,
    wis_bonus: 43
  }
  @invalid_attrs %{cha_bonus: nil, con_bonus: nil, desc: nil, dex_bonus: nil, int_bonus: nil, name: nil, size: nil, str_bonus: nil, wis_bonus: nil}

  def fixture(:race) do
    {:ok, race} = Races.create_race(@create_attrs)
    race
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all races", %{conn: conn} do
      conn = get(conn, Routes.race_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create race" do
    test "renders race when data is valid", %{conn: conn} do
      conn = post(conn, Routes.race_path(conn, :create), race: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.race_path(conn, :show, id))

      assert %{
               "id" => id,
               "cha_bonus" => 42,
               "con_bonus" => 42,
               "desc" => "some desc",
               "dex_bonus" => 42,
               "int_bonus" => 42,
               "name" => "some name",
               "size" => "some size",
               "str_bonus" => 42,
               "wis_bonus" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.race_path(conn, :create), race: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update race" do
    setup [:create_race]

    test "renders race when data is valid", %{conn: conn, race: %Race{id: id} = race} do
      conn = put(conn, Routes.race_path(conn, :update, race), race: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.race_path(conn, :show, id))

      assert %{
               "id" => id,
               "cha_bonus" => 43,
               "con_bonus" => 43,
               "desc" => "some updated desc",
               "dex_bonus" => 43,
               "int_bonus" => 43,
               "name" => "some updated name",
               "size" => "some updated size",
               "str_bonus" => 43,
               "wis_bonus" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, race: race} do
      conn = put(conn, Routes.race_path(conn, :update, race), race: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete race" do
    setup [:create_race]

    test "deletes chosen race", %{conn: conn, race: race} do
      conn = delete(conn, Routes.race_path(conn, :delete, race))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.race_path(conn, :show, race))
      end
    end
  end

  defp create_race(_) do
    race = fixture(:race)
    {:ok, race: race}
  end
end
