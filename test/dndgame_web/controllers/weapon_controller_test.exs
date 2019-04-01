defmodule DndgameWeb.WeaponControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Weapons
  alias Dndgame.Weapons.Weapon

  @create_attrs %{
    desc: "some desc",
    name: "some name",
    weapon_category: "some weapon_category"
  }
  @update_attrs %{
    desc: "some updated desc",
    name: "some updated name",
    weapon_category: "some updated weapon_category"
  }
  @invalid_attrs %{desc: nil, name: nil, weapon_category: nil}

  def fixture(:weapon) do
    {:ok, weapon} = Weapons.create_weapon(@create_attrs)
    weapon
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all weapons", %{conn: conn} do
      conn = get(conn, Routes.weapon_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create weapon" do
    test "renders weapon when data is valid", %{conn: conn} do
      conn = post(conn, Routes.weapon_path(conn, :create), weapon: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.weapon_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some desc",
               "name" => "some name",
               "weapon_category" => "some weapon_category"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.weapon_path(conn, :create), weapon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update weapon" do
    setup [:create_weapon]

    test "renders weapon when data is valid", %{conn: conn, weapon: %Weapon{id: id} = weapon} do
      conn = put(conn, Routes.weapon_path(conn, :update, weapon), weapon: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.weapon_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some updated desc",
               "name" => "some updated name",
               "weapon_category" => "some updated weapon_category"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, weapon: weapon} do
      conn = put(conn, Routes.weapon_path(conn, :update, weapon), weapon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete weapon" do
    setup [:create_weapon]

    test "deletes chosen weapon", %{conn: conn, weapon: weapon} do
      conn = delete(conn, Routes.weapon_path(conn, :delete, weapon))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.weapon_path(conn, :show, weapon))
      end
    end
  end

  defp create_weapon(_) do
    weapon = fixture(:weapon)
    {:ok, weapon: weapon}
  end
end
