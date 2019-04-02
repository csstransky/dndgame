defmodule DndgameWeb.MonsterControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Monsters
  alias Dndgame.Monsters.Monster

  @create_attrs %{
    ac: 42,
    desc: "some desc",
    hp: 42,
    initiative: 42,
    mp: 42,
    name: "some name",
    prof_bonus: 42,
    sp: 42,
    type: "some type"
  }
  @update_attrs %{
    ac: 43,
    desc: "some updated desc",
    hp: 43,
    initiative: 43,
    mp: 43,
    name: "some updated name",
    prof_bonus: 43,
    sp: 43,
    type: "some updated type"
  }
  @invalid_attrs %{ac: nil, desc: nil, hp: nil, initiative: nil, mp: nil, name: nil, prof_bonus: nil, sp: nil, type: nil}

  def fixture(:monster) do
    {:ok, monster} = Monsters.create_monster(@create_attrs)
    monster
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all monsters", %{conn: conn} do
      conn = get(conn, Routes.monster_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create monster" do
    test "renders monster when data is valid", %{conn: conn} do
      conn = post(conn, Routes.monster_path(conn, :create), monster: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.monster_path(conn, :show, id))

      assert %{
               "id" => id,
               "ac" => 42,
               "desc" => "some desc",
               "hp" => 42,
               "initiative" => 42,
               "mp" => 42,
               "name" => "some name",
               "prof_bonus" => 42,
               "sp" => 42,
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.monster_path(conn, :create), monster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update monster" do
    setup [:create_monster]

    test "renders monster when data is valid", %{conn: conn, monster: %Monster{id: id} = monster} do
      conn = put(conn, Routes.monster_path(conn, :update, monster), monster: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.monster_path(conn, :show, id))

      assert %{
               "id" => id,
               "ac" => 43,
               "desc" => "some updated desc",
               "hp" => 43,
               "initiative" => 43,
               "mp" => 43,
               "name" => "some updated name",
               "prof_bonus" => 43,
               "sp" => 43,
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, monster: monster} do
      conn = put(conn, Routes.monster_path(conn, :update, monster), monster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete monster" do
    setup [:create_monster]

    test "deletes chosen monster", %{conn: conn, monster: monster} do
      conn = delete(conn, Routes.monster_path(conn, :delete, monster))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.monster_path(conn, :show, monster))
      end
    end
  end

  defp create_monster(_) do
    monster = fixture(:monster)
    {:ok, monster: monster}
  end
end
