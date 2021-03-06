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
    get "/register", UserController, :new
    get "/login", PageController, :login
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
    resources "/users", UserController
    post "/game", PageController, :game
    post "/party", PageController, :party
    get "/worlds", PageController, :worlds
    resources "/characters", CharacterController
  end

    scope "/ajax/v1", DndgameWeb do
    pipe_through :ajax
        resources "/monsters", MonsterController, except: [:new, :edit]
        resources "/races", RaceController, except: [:new, :edit]
        resources "/skills", SkillController, except: [:new, :edit]
        resources "/spells", SpellController, except: [:new, :edit]
        resources "/weapons", WeaponController, except: [:new, :edit]
        resources "/select_weapons", WeaponController, except: [:new, :edit]
        resources "/armors", ArmorController, except: [:new, :edit]
        resources "/select_armors", ArmorController, except: [:new, :edit]
        resources "/classes", ClassController, except: [:new, :edit]
        resources "/attacks", AttackController, except: [:new, :edit]
        resources "/stats", StatsController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", DndgameWeb do
  #   pipe_through :api
  # end

  # puts the current user into the conn in order to be used in views
  # defp assign_current_user(conn, _) do
  #  assign(conn, :current_user, get_session(conn, :current_user))
  # end
end
