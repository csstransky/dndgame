defmodule Dndgame.Weapons do
  @moduledoc """
  The Weapons context.
  """

  import Ecto.Query, warn: false
  alias Dndgame.Repo

  alias Dndgame.Weapons.Weapon

  @doc """
  Returns the list of weapons.

  ## Examples

      iex> list_weapons()
      [%Weapon{}, ...]

  """
  def list_weapons do
    Repo.all(Weapon)
  end

  @doc """
  Gets a single weapon.

  Raises `Ecto.NoResultsError` if the Weapon does not exist.

  ## Examples

      iex> get_weapon!(123)
      %Weapon{}

      iex> get_weapon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_weapon!(id) do
    preloads = [:attack]
    Repo.get!(Weapon, id)
    |> Repo.preload(preloads)
  end

  def get_weapon_by_name(name) do
    Repo.get_by(Weapon, name: name)
  end

  @doc """
  Creates a weapon.

  ## Examples

      iex> create_weapon(%{field: value})
      {:ok, %Weapon{}}

      iex> create_weapon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_weapon(attrs \\ %{}) do
    %Weapon{}
    |> Weapon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a weapon.

  ## Examples

      iex> update_weapon(weapon, %{field: new_value})
      {:ok, %Weapon{}}

      iex> update_weapon(weapon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_weapon(%Weapon{} = weapon, attrs) do
    weapon
    |> Weapon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Weapon.

  ## Examples

      iex> delete_weapon(weapon)
      {:ok, %Weapon{}}

      iex> delete_weapon(weapon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_weapon(%Weapon{} = weapon) do
    Repo.delete(weapon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weapon changes.

  ## Examples

      iex> change_weapon(weapon)
      %Ecto.Changeset{source: %Weapon{}}

  """
  def change_weapon(%Weapon{} = weapon) do
    Weapon.changeset(weapon, %{})
  end
end
