defmodule DndgameWeb.ArmorControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Armors
  alias Dndgame.Armors.Armor

  @create_attrs %{
    armor_category: "some armor_category",
    base: 42,
    desc: "some desc",
    dex_bonus: true,
    name: "some name",
    stealth_disadvantage: true,
    str_minimum: 42
  }
  @update_attrs %{
    armor_category: "some updated armor_category",
    base: 43,
    desc: "some updated desc",
    dex_bonus: false,
    name: "some updated name",
    stealth_disadvantage: false,
    str_minimum: 43
  }
  @invalid_attrs %{armor_category: nil, base: nil, desc: nil, dex_bonus: nil, name: nil, stealth_disadvantage: nil, str_minimum: nil}

  def fixture(:armor) do
    {:ok, armor} = Armors.create_armor(@create_attrs)
    armor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all armors", %{conn: conn} do
      conn = get(conn, Routes.armor_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create armor" do
    test "renders armor when data is valid", %{conn: conn} do
      conn = post(conn, Routes.armor_path(conn, :create), armor: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.armor_path(conn, :show, id))

      assert %{
               "id" => id,
               "armor_category" => "some armor_category",
               "base" => 42,
               "desc" => "some desc",
               "dex_bonus" => true,
               "name" => "some name",
               "stealth_disadvantage" => true,
               "str_minimum" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.armor_path(conn, :create), armor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update armor" do
    setup [:create_armor]

    test "renders armor when data is valid", %{conn: conn, armor: %Armor{id: id} = armor} do
      conn = put(conn, Routes.armor_path(conn, :update, armor), armor: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.armor_path(conn, :show, id))

      assert %{
               "id" => id,
               "armor_category" => "some updated armor_category",
               "base" => 43,
               "desc" => "some updated desc",
               "dex_bonus" => false,
               "name" => "some updated name",
               "stealth_disadvantage" => false,
               "str_minimum" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, armor: armor} do
      conn = put(conn, Routes.armor_path(conn, :update, armor), armor: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete armor" do
    setup [:create_armor]

    test "deletes chosen armor", %{conn: conn, armor: armor} do
      conn = delete(conn, Routes.armor_path(conn, :delete, armor))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.armor_path(conn, :show, armor))
      end
    end
  end

  defp create_armor(_) do
    armor = fixture(:armor)
    {:ok, armor: armor}
  end
end
