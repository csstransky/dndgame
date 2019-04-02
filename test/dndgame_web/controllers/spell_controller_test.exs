defmodule DndgameWeb.SpellControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Spells
  alias Dndgame.Spells.Spell

  @create_attrs %{
    desc: "some desc",
    dice: "some dice",
    dice_bonus: 42,
    level_req: 42,
    mp_cost: 42,
    name: "some name",
    target: "some target",
    type: "some type"
  }
  @update_attrs %{
    desc: "some updated desc",
    dice: "some updated dice",
    dice_bonus: 43,
    level_req: 43,
    mp_cost: 43,
    name: "some updated name",
    target: "some updated target",
    type: "some updated type"
  }
  @invalid_attrs %{desc: nil, dice: nil, dice_bonus: nil, level_req: nil, mp_cost: nil, name: nil, target: nil, type: nil}

  def fixture(:spell) do
    {:ok, spell} = Spells.create_spell(@create_attrs)
    spell
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all spells", %{conn: conn} do
      conn = get(conn, Routes.spell_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create spell" do
    test "renders spell when data is valid", %{conn: conn} do
      conn = post(conn, Routes.spell_path(conn, :create), spell: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.spell_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some desc",
               "dice" => "some dice",
               "dice_bonus" => 42,
               "level_req" => 42,
               "mp_cost" => 42,
               "name" => "some name",
               "target" => "some target",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.spell_path(conn, :create), spell: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update spell" do
    setup [:create_spell]

    test "renders spell when data is valid", %{conn: conn, spell: %Spell{id: id} = spell} do
      conn = put(conn, Routes.spell_path(conn, :update, spell), spell: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.spell_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some updated desc",
               "dice" => "some updated dice",
               "dice_bonus" => 43,
               "level_req" => 43,
               "mp_cost" => 43,
               "name" => "some updated name",
               "target" => "some updated target",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, spell: spell} do
      conn = put(conn, Routes.spell_path(conn, :update, spell), spell: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete spell" do
    setup [:create_spell]

    test "deletes chosen spell", %{conn: conn, spell: spell} do
      conn = delete(conn, Routes.spell_path(conn, :delete, spell))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.spell_path(conn, :show, spell))
      end
    end
  end

  defp create_spell(_) do
    spell = fixture(:spell)
    {:ok, spell: spell}
  end
end
