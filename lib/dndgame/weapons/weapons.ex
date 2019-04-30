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
    |> Repo.preload([:attack])
  end

  def select_default_weapons do
    default_id = 1
    race = Repo.get!(Dndgame.Races.Race, default_id)
    class = Repo.get!(Dndgame.Classes.Class, default_id)
    weapon_profs = Enum.uniq(race.weapon_prof_array ++ class.weapon_prof_array)
    query = from weapon in Weapon,
            where: weapon.weapon_category in ^weapon_profs
                or weapon.name in ^weapon_profs,
            select: weapon
    Repo.all(query)
    |> Enum.map(&{&1.name, &1.id})
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

  def get_select_weapons(weapons, race, class) do
    weapon_profs = Enum.uniq(race.weapon_prof_array ++ class.weapon_prof_array)
    weapons
    |> Enum.filter(fn weapon -> is_selectable_weapon(weapon, weapon_profs) end)
  end

  def is_selectable_weapon(weapon, weapon_profs) do
    weapon_name = String.downcase(weapon.name)
    weapon_category = String.downcase(weapon.weapon_category)
    weapon_profs = weapon_profs
    |> Enum.map(fn weapon_prof -> String.downcase(weapon_prof) end)
    Enum.member?(weapon_profs, weapon_name)
    || Enum.member?(weapon_profs, weapon_category)
  end
end
