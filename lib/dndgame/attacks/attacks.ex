defmodule Dndgame.Attacks do
  @moduledoc """
  The Attacks context.
  """

  import Ecto.Query, warn: false
  alias Dndgame.Repo

  alias Dndgame.Attacks.Attack

  @doc """
  Returns the list of attacks.

  ## Examples

      iex> list_attacks()
      [%Attack{}, ...]

  """
  def list_attacks do
    Repo.all(Attack)
  end

  @doc """
  Gets a single attack.

  Raises `Ecto.NoResultsError` if the Attack does not exist.

  ## Examples

      iex> get_attack!(123)
      %Attack{}

      iex> get_attack!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attack!(id), do: Repo.get!(Attack, id)

  def get_attack_by_name(name) do
    Repo.get_by(Attack, name: name)
  end

  @doc """
  Creates a attack.

  ## Examples

      iex> create_attack(%{field: value})
      {:ok, %Attack{}}

      iex> create_attack(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attack(attrs \\ %{}) do
    %Attack{}
    |> Attack.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attack.

  ## Examples

      iex> update_attack(attack, %{field: new_value})
      {:ok, %Attack{}}

      iex> update_attack(attack, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attack(%Attack{} = attack, attrs) do
    attack
    |> Attack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attack.

  ## Examples

      iex> delete_attack(attack)
      {:ok, %Attack{}}

      iex> delete_attack(attack)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attack(%Attack{} = attack) do
    Repo.delete(attack)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attack changes.

  ## Examples

      iex> change_attack(attack)
      %Ecto.Changeset{source: %Attack{}}

  """
  def change_attack(%Attack{} = attack) do
    Attack.changeset(attack, %{})
  end
end
