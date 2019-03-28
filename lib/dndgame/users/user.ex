defmodule Dndgame.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :admin])
    # TODO: Do we need to require passwords if we're going to use Google auth?
    |> validate_required([:email, :admin])
    |> unique_constraint(:email)
  end
end
