defmodule DndgameWeb.CharacterView do
  use DndgameWeb, :view
  alias DndgameWeb.CharacterView

  def render("index.json", %{characters: characters}) do
    %{data: render_many(characters, CharacterView, "character.json")}
  end

  def render("show.json", %{character: character}) do
    %{data: render_one(character, CharacterView, "character.json")}
  end

  def render("character.json", %{character: character}) do
    %{id: character.id,
      name: character.name,
      str: character.str,
      dex: character.dex,
      con: character.con,
      int: character.int,
      wis: character.wis,
      cha: character.cha,
      initiative: character.initiative,
      hp: character.hp,
      ac: character.ac,
      mp: character.mp,
      sp: character.sp,
      level: character.level,
      exp: character.exp}
  end
end
