defmodule Dndgame.Spells do
  @moduledoc """
  The Spells context.
  """

  import Ecto.Query, warn: false
  alias Dndgame.Repo

  alias Dndgame.Spells.Spell

  @doc """
  Returns the list of spells.

  ## Examples

      iex> list_spells()
      [%Spell{}, ...]

  """
  def list_spells do
    Repo.all(Spell)
  end

  @doc """
  Gets a single spell.

  Raises `Ecto.NoResultsError` if the Spell does not exist.

  ## Examples

      iex> get_spell!(123)
      %Spell{}

      iex> get_spell!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spell!(id), do: Repo.get!(Spell, id)

  def get_spell_by_name(name) do
    Repo.get_by(Spell, name: name)
  end

  @doc """
  Creates a spell.

  ## Examples

      iex> create_spell(%{field: value})
      {:ok, %Spell{}}

      iex> create_spell(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spell(attrs \\ %{}) do
    %Spell{}
    |> Spell.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spell.

  ## Examples

      iex> update_spell(spell, %{field: new_value})
      {:ok, %Spell{}}

      iex> update_spell(spell, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spell(%Spell{} = spell, attrs) do
    spell
    |> Spell.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Spell.

  ## Examples

      iex> delete_spell(spell)
      {:ok, %Spell{}}

      iex> delete_spell(spell)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spell(%Spell{} = spell) do
    Repo.delete(spell)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spell changes.

  ## Examples

      iex> change_spell(spell)
      %Ecto.Changeset{source: %Spell{}}

  """
  def change_spell(%Spell{} = spell) do
    Spell.changeset(spell, %{})
  end
end
