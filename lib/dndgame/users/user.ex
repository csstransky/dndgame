defmodule Dndgame.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :password_hash, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :admin, :token])
    # TODO: Do we need to require passwords if we're going to use Google auth?
    |> validate_required([:email, :admin])
    |> unique_constraint(:email)
  end

  def find_or_empty(email) do
    user = Repo.get_by(Dndgame.Users.User, email: email)
    if user do
      IO.inspect("user already exists")
      user
    else
      IO.inspect("creating new user")
      %Dndgame.Users.User{email: email}
    end
  end

  def insert_or_update(params) do
    IO.inspect("insert or update")
    user = find_or_empty(params.email)
    Repo.insert_or_update!(changeset(user, params))
  end


end
