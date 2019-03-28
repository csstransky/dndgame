defmodule DndgameWeb.AttackControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Attacks
  alias Dndgame.Attacks.Attack

  @create_attrs %{
    attack_bonus: 42,
    damage_bonus: 42,
    damage_dice: "some damage_dice",
    desc: "some desc",
    name: "some name",
    target: "some target",
    type: "some type"
  }
  @update_attrs %{
    attack_bonus: 43,
    damage_bonus: 43,
    damage_dice: "some updated damage_dice",
    desc: "some updated desc",
    name: "some updated name",
    target: "some updated target",
    type: "some updated type"
  }
  @invalid_attrs %{attack_bonus: nil, damage_bonus: nil, damage_dice: nil, desc: nil, name: nil, target: nil, type: nil}

  def fixture(:attack) do
    {:ok, attack} = Attacks.create_attack(@create_attrs)
    attack
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all attacks", %{conn: conn} do
      conn = get(conn, Routes.attack_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create attack" do
    test "renders attack when data is valid", %{conn: conn} do
      conn = post(conn, Routes.attack_path(conn, :create), attack: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.attack_path(conn, :show, id))

      assert %{
               "id" => id,
               "attack_bonus" => 42,
               "damage_bonus" => 42,
               "damage_dice" => "some damage_dice",
               "desc" => "some desc",
               "name" => "some name",
               "target" => "some target",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.attack_path(conn, :create), attack: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update attack" do
    setup [:create_attack]

    test "renders attack when data is valid", %{conn: conn, attack: %Attack{id: id} = attack} do
      conn = put(conn, Routes.attack_path(conn, :update, attack), attack: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.attack_path(conn, :show, id))

      assert %{
               "id" => id,
               "attack_bonus" => 43,
               "damage_bonus" => 43,
               "damage_dice" => "some updated damage_dice",
               "desc" => "some updated desc",
               "name" => "some updated name",
               "target" => "some updated target",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, attack: attack} do
      conn = put(conn, Routes.attack_path(conn, :update, attack), attack: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete attack" do
    setup [:create_attack]

    test "deletes chosen attack", %{conn: conn, attack: attack} do
      conn = delete(conn, Routes.attack_path(conn, :delete, attack))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.attack_path(conn, :show, attack))
      end
    end
  end

  defp create_attack(_) do
    attack = fixture(:attack)
    {:ok, attack: attack}
  end
end
