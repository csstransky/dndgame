# from ntuck

defmodule DndgameWeb.AuthController do
  use DndgameWeb, :controller

  alias Dndgame.Users
  alias Dndgame.Users.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index2(conn, %{"provider" => provider}) do
    IO.inspect("running authorize_url and redirecting")
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
    IO.inspect("starting callback")
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, client)


    IO.inspect("insert or update 2")
    insert_or_update(user)
    IO.inspect("insert or update finished")

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
    IO.inspect("insert or update")
    user = find_or_empty(params.email)
    Repo.insert_or_update!(changeset(user, params))
  end

  defp authorize_url!("google"),   do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("google", code)  do
    Google.get_token!(code: code)
  end
  defp get_token!(_, _), do: raise "No matching provider available"


  defp get_user!("google", client) do
    IO.inspect(client)
    %{body: user, status_code: status} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    %{email: user["email"], domain: user["hd"], email_verified: user["email_verified"], avatar: user["picture"]}
  end

end
