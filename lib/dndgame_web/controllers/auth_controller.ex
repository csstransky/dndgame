# from ntuck

defmodule DndgameWeb.AuthController do
  use DndgameWeb, :controller

  alias Dndgame.Users
  alias Dndgame.Users.User

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, client)
    IO.inspect(user)

    #### insert_or_update(user)

    # Store the token in the "database"

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  def insert_or_update(params) do
    user = find_or_empty(params.email)
    Repo.insert_or_update!(Dndgame.Users.User.changeset(user, params))
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

  defp authorize_url!("github"),   do: GitHub.authorize_url!
  defp authorize_url!("google") do
    Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  end
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("github", code),   do: GitHub.get_token!(code: code)
  defp get_token!("google", code)  do
    IO.inspect("Token code below")
    IO.inspect(code)
    Google.get_token!(code: code)
  end
  defp get_token!(_, _), do: raise "No matching provider available"


  defp get_user!("google", client) do
    IO.inspect(client)
    IO.inspect(OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect"))
    %{body: user} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{name: user["name"], avatar: user["picture"]}
  end

  defp get_user!("github", client) do
    IO.inspect(OAuth2.Client.get!(client, "/users"))
    %{body: user} = OAuth2.Client.get!(client, "/users")
    %{name: user["name"], avatar: user["avatar_url"]}
  end

end
