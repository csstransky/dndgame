defmodule DndgameWeb.LoginController do
  use DndgameWeb, :controller
  @moduledoc false

  def login(conn, _params) do
    render(conn, "login.html")
  end
end
