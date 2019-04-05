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
      token_url: "https://www.googleapis.com/oauth2/v1/tokeninfo"] #this is test url
  end

  # Public API

  def client do
    Application.get_env(:dndgame, Google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    IO.inspect("running auth url in OAuth2.client")
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    IO.inspect("CHECKING TOKEN")
    IO.inspect(Keyword.merge(params, client_secret: client().client_secret))
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client = client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
    IO.inspect("WHERE IS THE TOKEN?")
    IO.inspect(client)
    client
  end
end
