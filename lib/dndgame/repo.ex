defmodule Dndgame.Repo do
  use Ecto.Repo,
    otp_app: :dndgame,
    adapter: Ecto.Adapters.Postgres
end
