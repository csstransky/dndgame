defmodule Dndgame.SkillsTest do
  use Dndgame.DataCase

  alias Dndgame.Skills

  describe "skills" do
    alias Dndgame.Skills.Skill

    @valid_attrs %{desc: "some desc", dice: "some dice", dice_bonus: 42, level_req: 42, name: "some name", sp_cost: 42, target: "some target", type: "some type"}
    @update_attrs %{desc: "some updated desc", dice: "some updated dice", dice_bonus: 43, level_req: 43, name: "some updated name", sp_cost: 43, target: "some updated target", type: "some updated type"}
    @invalid_attrs %{desc: nil, dice: nil, dice_bonus: nil, level_req: nil, name: nil, sp_cost: nil, target: nil, type: nil}

    def skill_fixture(attrs \\ %{}) do
      {:ok, skill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Skills.create_skill()

      skill
    end

    test "list_skills/0 returns all skills" do
      skill = skill_fixture()
      assert Skills.list_skills() == [skill]
    end

    test "get_skill!/1 returns the skill with given id" do
      skill = skill_fixture()
      assert Skills.get_skill!(skill.id) == skill
    end

    test "create_skill/1 with valid data creates a skill" do
      assert {:ok, %Skill{} = skill} = Skills.create_skill(@valid_attrs)
      assert skill.desc == "some desc"
      assert skill.dice == "some dice"
      assert skill.dice_bonus == 42
      assert skill.level_req == 42
      assert skill.name == "some name"
      assert skill.sp_cost == 42
      assert skill.target == "some target"
      assert skill.type == "some type"
    end

    test "create_skill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Skills.create_skill(@invalid_attrs)
    end

    test "update_skill/2 with valid data updates the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{} = skill} = Skills.update_skill(skill, @update_attrs)
      assert skill.desc == "some updated desc"
      assert skill.dice == "some updated dice"
      assert skill.dice_bonus == 43
      assert skill.level_req == 43
      assert skill.name == "some updated name"
      assert skill.sp_cost == 43
      assert skill.target == "some updated target"
      assert skill.type == "some updated type"
    end

    test "update_skill/2 with invalid data returns error changeset" do
      skill = skill_fixture()
      assert {:error, %Ecto.Changeset{}} = Skills.update_skill(skill, @invalid_attrs)
      assert skill == Skills.get_skill!(skill.id)
    end

    test "delete_skill/1 deletes the skill" do
      skill = skill_fixture()
      assert {:ok, %Skill{}} = Skills.delete_skill(skill)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_skill!(skill.id) end
    end

    test "change_skill/1 returns a skill changeset" do
      skill = skill_fixture()
      assert %Ecto.Changeset{} = Skills.change_skill(skill)
    end
  end
end
