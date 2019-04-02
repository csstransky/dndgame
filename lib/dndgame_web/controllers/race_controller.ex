defmodule DndgameWeb.RaceController do
  use DndgameWeb, :controller

  alias Dndgame.Races
  alias Dndgame.Races.Race

  action_fallback DndgameWeb.FallbackController

  def index(conn, _params) do
    races = Races.list_races()
    render(conn, "index.json", races: races)
  end

  def create(conn, %{"race" => race_params}) do
    with {:ok, %Race{} = race} <- Races.create_race(race_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.race_path(conn, :show, race))
      |> render("show.json", race: race)
    end
  end

  def show(conn, %{"id" => id}) do
    race = Races.get_race!(id)
    render(conn, "show.json", race: race)
  end

  def update(conn, %{"id" => id, "race" => race_params}) do
    race = Races.get_race!(id)

    with {:ok, %Race{} = race} <- Races.update_race(race, race_params) do
      render(conn, "show.json", race: race)
    end
  end

  def delete(conn, %{"id" => id}) do
    race = Races.get_race!(id)

    with {:ok, %Race{}} <- Races.delete_race(race) do
      send_resp(conn, :no_content, "")
    end
  end
end
