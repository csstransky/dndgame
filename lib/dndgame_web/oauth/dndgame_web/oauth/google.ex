# From ntuck

defmodule Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  """
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: Google,
      site: "https://accounts.google.com",
      authorize_url: "/o/oauth2/auth",
      redirect_uri: "http://localhost:4000/auth/google/callback",
      token_url: "https://www.googleapis.com/oauth2/v4/token"]
  end

  # Public API

  def client do
    IO.inspect("Running client in google.ex")
    Application.get_env(:dndgame, Google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    IO.inspect("running authorize_url! in google.ex")
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    IO.inspect("Running get_token! in google.ex")
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    IO.inspect("Running authorize_url in google.ex")
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end