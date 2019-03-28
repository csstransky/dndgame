defmodule DndgameWeb.Router do
  use DndgameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DndgameWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", AuthController, :index
    resources "/users", UserController
  end

  scope "/auth", Dndgame do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", DndgameWeb do
  #   pipe_through :api
  # end

  # puts the current user into the conn in order to be used in views
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
