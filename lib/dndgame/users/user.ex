defmodule Dndgame.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true



    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :password ,:admin])
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> validate_required([:email])
    |> put_pass_hash()
  end

  # Password validation
  # From Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  def valid_password?(_), do: {:error, "The password is too short"}

  def put_pass_hash(%Ecto.Changeset{
    valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  def put_pass_hash(changeset), do: changeset
end
