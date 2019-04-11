# from ntuck

defmodule DndgameWeb.AuthController do
  use DndgameWeb, :controller


  alias Dndgame.Users
  alias Dndgame.Users.User
  alias Dndgame.Repo


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def test(conn, _params) do
    render(conn, "index.html")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def spotifyAuthorization(conn, _params) do
    redirect conn, external: Spotify.Authorization.url
  end

  def spotifyAuthentication(conn, params) do
    IO.inspect("ENTERED INTO SPOTIFY AUTHENTICATION COMMAND")
    case Spotify.Authentication.authenticate(conn, params) do
      {:ok, conn } ->
        {:ok, profile} = Spotify.Profile.me(conn)
        IO.inspect(profile.display_name)
        IO.inspect(profile.id)
        DndgameWeb.SessionController.create(conn, profile.display_name, profile.id)
        redirect conn, to: "/"
      { :error, reason, conn }-> redirect conn, to: "/error"
    end
  end

end