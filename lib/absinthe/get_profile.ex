defmodule Auth0Jwt.Absinthe.GetProfile do
  @moduledoc"""
    GetProfile uses the claims attribute set by RequireAuthenticated in the absinthe context

    Notes:
      You need to have this come AFTER RequireAuthenticated.
      This is not a Plug middleware. This is Absinthe based.

  """
  @behaviour Absinthe.Middleware
  alias Absinthe.Resolution

  #if the resolution is already resolved, do nothing
  def call(%Absinthe.Resolution{ state: :resolved }=resolution, _) do
    resolution
  end

  def call(resolution, _) do
    IO.inspect(resolution)
    case get_id(resolution) do
      {:ok, id} -> case fetch_profile(id) do
        {:ok, profile} ->
          %{context: context} = resolution
          new_context = Map.put(context, :profile, profile)
          Map.put(resolution, :context, new_context)
        {:error, error, message} ->
          resolution |> Resolution.put_result({:error, message})
      end
      {:error, error} ->
        resolution |> Resolution.put_result({:error, "invalid claims, could not retrieve profile"})
    end
  end

  @doc"""
    user: "google-oauth2|105971703011007196422"
    Auth0Jwt.Absinthe.GetProile.fetch_profile("google-oauth2|105971703011007196422")
  """
  def fetch_profile(auth0_id) do
    case Auth0Ex.Management.User.get(auth0_id) do
      {:ok, profile} ->
        {:ok, profile}
      {:error, body, _} -> case Poison.decode(body) do
        {:error, _,} -> {:error, "UnknownError", "an unidentified error occurred"}
        {:ok, body} ->
          {:error, Map.get(body, "error"), Map.get(body, "message")}
      end
    end
  end

  def get_id(resolution) do
    case Map.get(resolution, :context) do
      %{ claims: %{ "sub" => auth0_id }} -> {:ok, auth0_id}
      _ -> {:error, "Unauthorized"}
    end
  end




end
