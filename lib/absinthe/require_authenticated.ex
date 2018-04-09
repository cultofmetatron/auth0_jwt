defmodule Auth0Jwt.Absinthe.RequireAuthenicated do
  @moduledoc """

  """

  @behaviour Absinthe.Middleware
  def call(resolution, _) do
    IO.inspect("%%%%%%%%%%")
    case resolution.context do
      %{ login_status: :authenticated, claims: claims } ->
        resolution
      %{ login_status: :unauthenticated } ->
        IO.inspect("error happens after this")
        res = Absinthe.Resolution.put_result(resolution, { :error, "unauthenticated" })
        #IO.inspect(res)
        res
      %{ error: error } ->
        resolution |> Absinthe.Resolution.put_result({ :error, error })
    end
  end
end
