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

  def find_or_empty(name) do
    user = Repo.get_by(Dndgame.User, name: name)
    if user do
      user
    else
      %Dndgame.User{name: name}
    end
  end

  def insert_or_update(params) do
    user = find_or_empty(params.name)
    Repo.insert_or_update!(changeset(user, params))
  end


end
