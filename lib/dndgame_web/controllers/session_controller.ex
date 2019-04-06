defmodule DndgameWeb.SessionController do
  use DndgameWeb, :controller

  def create(conn, %{"email" => email, "password" => pass }) do
    IO.inspect({email, pass})
    user = get_and_auth_user(email, pass)
    IO.inspect(user)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: Routes.page_path(conn, :index))
      |> IO.inspect()
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end


  def get_and_auth_user(email, password) do
    user = Dndgame.Users.get_user_by_email(email)
    case Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
