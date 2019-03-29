defmodule Dndgame.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias Dndgame.Repo

  alias Dndgame.Characters.Character

  @doc """
  Returns the list of characters.

  ## Examples

      iex> list_characters()
      [%Character{}, ...]

  """
  def list_characters do
    preloads = [:armor, :weapon, :race, :class, :user]
    Repo.all(Character)
    |> Repo.preload(preloads)
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.

  ## Examples

      iex> get_character!(123)
      %Character{}

      iex> get_character!(456)
      ** (Ecto.NoResultsError)

  """
  def get_character!(id) do
    Repo.one! from c in Character,
      where: c.id == ^id,
      preload: [:armor]
   end

  def get_character(id), do: Repo.get(Character, id)

  @doc """
  Creates a character.

  ## Examples

      iex> create_character(%{field: value})
      {:ok, %Character{}}

      iex> create_character(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character.

  ## Examples

      iex> update_character(character, %{field: new_value})
      {:ok, %Character{}}

      iex> update_character(character, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Character.

  ## Examples

      iex> delete_character(character)
      {:ok, %Character{}}

      iex> delete_character(character)
      {:error, %Ecto.Changeset{}}

  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.

  ## Examples

      iex> change_character(character)
      %Ecto.Changeset{source: %Character{}}

  """
  def change_character(%Character{} = character) do
    Character.changeset(character, %{})
  end


      #field :ac, :integer
  def get_ac(%Character{} = character) do
    armor = character.armor
    if (armor.dex_bonus) do
      armor.base + get_stat_modifier(character.dex)
    else
      armor.base
    end
  end

  def get_hp(%Character{} = character) do
    class = character.class
    level = get_level(character)
    hit_die = class.hit_die
    # TODO Anyone know how to do multi-line arthimetic and make Elixir happy?
    hit_die + (level - 1) * floor((hit_die / 2 + 1)) +  level * get_stat_modifier(character.con)
  end

  # TODO More attractive way to do this?
  def get_mp(%Character{} = character) do
    class_name = String.downcase(character.class.name)
    level = get_level(character)
    prof_bonus = get_prof_bonus(character)
    cond do
      class_name == "barbarian" ->
        0
      class_name == "paladin" ->
        floor((level + prof_bonus + 1) / 2)
      true ->
        level + prof_bonus + 1
    end
  end

  # TODO This is also kinda inefficent
  def get_sp(%Character{} = character) do
    class_name = String.downcase(character.class.name)
    level = get_level(character)
    prof_bonus = get_prof_bonus(character)
    cond do
      class_name == "wizard" ->
        ceil((level + prof_bonus + 1) / 4)
      class_name == "Paladin" ->
        ceil((level + prof_bonus + 1) / 2)
      true ->
        level + prof_bonus + 1
    end
  end

  def get_initiative(%Character{} = character) do
    # TODO I feel like something is missing
    get_stat_modifier(character.dex)
  end

  def get_level(%Character{} = character) do
    # Apparently through a bunch of playtesting, Wizards specifically made
    # leveling up easier on some spots (like 10 to 11), so there actually isn't
    # a mathematical way to calculate for level with exp.
    exp = character.exp
    # I may just make this a forumla in the future because this is kinda ugly
    cond do
      exp >= 64000 ->
        10
      exp >= 48000 ->
        9
      exp >= 34000 ->
        8
      exp >= 23000 ->
        7
      exp >= 14000 ->
        6
      exp >= 6500 ->
        5
      exp >= 2700 ->
        4
      exp >= 900 ->
        3
      exp >= 300 ->
        2
      true ->
        1
    end
  end

  def get_stat_modifier(stat) do
    floor((stat - 10) / 2)
  end

  def get_prof_bonus(character) do
    ceil(get_level(character) / 4) + 1
  end
end
