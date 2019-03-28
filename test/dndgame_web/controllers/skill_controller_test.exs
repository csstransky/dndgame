defmodule DndgameWeb.SkillControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Skills
  alias Dndgame.Skills.Skill

  @create_attrs %{
    desc: "some desc",
    dice: "some dice",
    dice_bonus: 42,
    level_req: 42,
    name: "some name",
    sp_cost: 42,
    target: "some target",
    type: "some type"
  }
  @update_attrs %{
    desc: "some updated desc",
    dice: "some updated dice",
    dice_bonus: 43,
    level_req: 43,
    name: "some updated name",
    sp_cost: 43,
    target: "some updated target",
    type: "some updated type"
  }
  @invalid_attrs %{desc: nil, dice: nil, dice_bonus: nil, level_req: nil, name: nil, sp_cost: nil, target: nil, type: nil}

  def fixture(:skill) do
    {:ok, skill} = Skills.create_skill(@create_attrs)
    skill
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all skills", %{conn: conn} do
      conn = get(conn, Routes.skill_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create skill" do
    test "renders skill when data is valid", %{conn: conn} do
      conn = post(conn, Routes.skill_path(conn, :create), skill: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.skill_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some desc",
               "dice" => "some dice",
               "dice_bonus" => 42,
               "level_req" => 42,
               "name" => "some name",
               "sp_cost" => 42,
               "target" => "some target",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.skill_path(conn, :create), skill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update skill" do
    setup [:create_skill]

    test "renders skill when data is valid", %{conn: conn, skill: %Skill{id: id} = skill} do
      conn = put(conn, Routes.skill_path(conn, :update, skill), skill: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.skill_path(conn, :show, id))

      assert %{
               "id" => id,
               "desc" => "some updated desc",
               "dice" => "some updated dice",
               "dice_bonus" => 43,
               "level_req" => 43,
               "name" => "some updated name",
               "sp_cost" => 43,
               "target" => "some updated target",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, skill: skill} do
      conn = put(conn, Routes.skill_path(conn, :update, skill), skill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete skill" do
    setup [:create_skill]

    test "deletes chosen skill", %{conn: conn, skill: skill} do
      conn = delete(conn, Routes.skill_path(conn, :delete, skill))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.skill_path(conn, :show, skill))
      end
    end
  end

  defp create_skill(_) do
    skill = fixture(:skill)
    {:ok, skill: skill}
  end
end
