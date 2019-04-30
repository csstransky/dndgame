defmodule Dndgame.Armors do
  @moduledoc """
  The Armors context.
  """

  import Ecto.Query, warn: false
  alias Dndgame.Repo

  alias Dndgame.Armors.Armor

  @doc """
  Returns the list of armors.

  ## Examples

      iex> list_armors()
      [%Armor{}, ...]

  """
  def list_armors do
    Repo.all(Armor)
  end

  def select_default_armors do
    default_id = 1
    race = Repo.get!(Dndgame.Races.Race, default_id)
    class = Repo.get!(Dndgame.Classes.Class, default_id)
    armor_profs = Enum.uniq(race.armor_prof_array ++ class.armor_prof_array)
    query = from armor in Armor,
            where: armor.armor_category in ^armor_profs
                or armor.name in ^armor_profs,
            select: armor
    Repo.all(query)
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc """
  Gets a single armor.

  Raises `Ecto.NoResultsError` if the Armor does not exist.

  ## Examples

      iex> get_armor!(123)
      %Armor{}

      iex> get_armor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_armor!(id), do: Repo.get!(Armor, id)

  def get_armor_by_name(name) do
    Repo.get_by(Armor, name: name)
  end

  @doc """
  Creates a armor.

  ## Examples

      iex> create_armor(%{field: value})
      {:ok, %Armor{}}

      iex> create_armor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_armor(attrs \\ %{}) do
    %Armor{}
    |> Armor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a armor.

  ## Examples

      iex> update_armor(armor, %{field: new_value})
      {:ok, %Armor{}}

      iex> update_armor(armor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_armor(%Armor{} = armor, attrs) do
    armor
    |> Armor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Armor.

  ## Examples

      iex> delete_armor(armor)
      {:ok, %Armor{}}

      iex> delete_armor(armor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_armor(%Armor{} = armor) do
    Repo.delete(armor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking armor changes.

  ## Examples

      iex> change_armor(armor)
      %Ecto.Changeset{source: %Armor{}}

  """
  def change_armor(%Armor{} = armor) do
    Armor.changeset(armor, %{})
  end

  def get_select_armors(armors, race, class, str) do
    total_str = str + race.str_bonus
    armor_profs = Enum.uniq(race.armor_prof_array ++ class.armor_prof_array)
    armors
    |> Enum.filter(fn armor ->
      is_selectable_armor(armor, armor_profs)
      && total_str >= armor.str_minimum
    end)
  end

  def is_selectable_armor(armor, armor_profs) do
    armor_name = String.downcase(armor.name)
    armor_category = String.downcase(armor.armor_category)
    armor_profs = armor_profs
    |> Enum.map(fn armor_prof -> String.downcase(armor_prof) end)
    Enum.member?(armor_profs, armor_name)
    || Enum.member?(armor_profs, armor_category)
  end
end
