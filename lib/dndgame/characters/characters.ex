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
    IO.inspect(armor)
    133
  end

  def get_hp(%Character{} = character) do
    133
  end

  def get_mp(%Character{} = character) do
    133
  end

  def get_sp(%Character{} = character) do
    133
  end

  def get_initiative(%Character{} = character) do
    133
  end

  def get_level(%Character{} = character) do
    133
  end
end
