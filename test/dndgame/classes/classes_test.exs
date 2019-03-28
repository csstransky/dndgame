defmodule Dndgame.ClassesTest do
  use Dndgame.DataCase

  alias Dndgame.Classes

  describe "classes" do
    alias Dndgame.Classes.Class

    @valid_attrs %{desc: "some desc", hit_dice: "some hit_dice", name: "some name"}
    @update_attrs %{desc: "some updated desc", hit_dice: "some updated hit_dice", name: "some updated name"}
    @invalid_attrs %{desc: nil, hit_dice: nil, name: nil}

    def class_fixture(attrs \\ %{}) do
      {:ok, class} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_class()

      class
    end

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Classes.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Classes.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      assert {:ok, %Class{} = class} = Classes.create_class(@valid_attrs)
      assert class.desc == "some desc"
      assert class.hit_dice == "some hit_dice"
      assert class.name == "some name"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      assert {:ok, %Class{} = class} = Classes.update_class(class, @update_attrs)
      assert class.desc == "some updated desc"
      assert class.hit_dice == "some updated hit_dice"
      assert class.name == "some updated name"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
      assert class == Classes.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Classes.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Classes.change_class(class)
    end
  end
end
