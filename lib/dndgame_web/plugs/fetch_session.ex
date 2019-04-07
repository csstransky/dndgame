defmodule DndgameWeb.Plugs.FetchSession do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    IO.inspect("Running call in fetch_session.ex")
    user = Dndgame.Users.get_user(get_session(conn, :user_id) || -1)
    if user do
      IO.inspect("User is assigned")
      assign(conn, :current_user, user)
    else
      IO.inspect("User is unassigned")
      assign(conn, :current_user, nil)
    end
  end

end
