defmodule DndgameWeb.Router do
  use DndgameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DndgameWeb.Plugs.FetchSession
  end

  pipeline :ajax do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug DndgameWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DndgameWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/characters", CharacterController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

    scope "/ajax", DndgameWeb do
    pipe_through :ajax
  end

  # Other scopes may use custom stacks.
  # scope "/api", DndgameWeb do
  #   pipe_through :api
  # end
end
