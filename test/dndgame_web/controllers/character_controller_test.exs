defmodule DndgameWeb.CharacterControllerTest do
  use DndgameWeb.ConnCase

  alias Dndgame.Characters

  @create_attrs %{ac: 42, cha: 42, con: 42, dex: 42, exp: 42, hp: 42, initiative: 42, int: 42, level: 42, mp: 42, name: "some name", sp: 42, str: 42, wis: 42}
  @update_attrs %{ac: 43, cha: 43, con: 43, dex: 43, exp: 43, hp: 43, initiative: 43, int: 43, level: 43, mp: 43, name: "some updated name", sp: 43, str: 43, wis: 43}
  @invalid_attrs %{ac: nil, cha: nil, con: nil, dex: nil, exp: nil, hp: nil, initiative: nil, int: nil, level: nil, mp: nil, name: nil, sp: nil, str: nil, wis: nil}

  def fixture(:character) do
    {:ok, character} = Characters.create_character(@create_attrs)
    character
  end

  describe "index" do
    test "lists all characters", %{conn: conn} do
      conn = get(conn, Routes.character_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Characters"
    end
  end

  describe "new character" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.character_path(conn, :new))
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "create character" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.character_path(conn, :show, id)

      conn = get(conn, Routes.character_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Character"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Character"
    end
  end

  describe "edit character" do
    setup [:create_character]

    test "renders form for editing chosen character", %{conn: conn, character: character} do
      conn = get(conn, Routes.character_path(conn, :edit, character))
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "update character" do
    setup [:create_character]

    test "redirects when data is valid", %{conn: conn, character: character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @update_attrs)
      assert redirected_to(conn) == Routes.character_path(conn, :show, character)

      conn = get(conn, Routes.character_path(conn, :show, character))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, character: character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Character"
    end
  end

  describe "delete character" do
    setup [:create_character]

    test "deletes chosen character", %{conn: conn, character: character} do
      conn = delete(conn, Routes.character_path(conn, :delete, character))
      assert redirected_to(conn) == Routes.character_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.character_path(conn, :show, character))
      end
    end
  end

  defp create_character(_) do
    character = fixture(:character)
    {:ok, character: character}
  end
end
