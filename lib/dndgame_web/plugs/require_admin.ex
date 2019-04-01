defmodule DndgameWeb.Plugs.RequireAdmin do
  use DndgameWeb, :controller

  def init(args), do: args

  def call(conn, _params) do
    user = conn.assigns[:current_user]
    if user.admin do
      conn
    else
      conn
      |> put_flash(:error, "You can't do that.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    end
  end
end
