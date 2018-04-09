defmodule Auth0Jwt.Absinthe.GetToken do
  @moduledoc"""
    middleware for absinthe.
    Uses the jwt to pull in the jwt token and extract information from auth0

    Given:
      the token is on headers Authorization: Bearer ${token}
      the token of auth0 contains data pertinent for introspecting the user

    Procedure
      extract clams from the jwt and add them to the

  """

  import Plug.Conn
  import Joken

  def init(opts), do: opts

  def call(conn, _) do
    token = get_token(conn)
    if token do
      case verify_token(token) do
        %Joken.Token{error: nil, errors: [], claims: claims } ->
          # no errors, verify it here
          conn
          |> set_authenticated(claims)
        %Joken.Token{error: error} ->
          #errors found, log them here
          set_token_error(conn, error)
      end
    else
      set_unauthenticated(conn)
    end
  end

  def get_token(conn) do
    bearer_token = get_req_header(conn, "authorization")
    case bearer_token do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  def verify_token(token) do
    verifier()
    |> with_json_module(Poison)
    |> with_compact_token(token)
    |> Joken.verify
  end

  def verifier do
    key = Application.get_env(:auth0_ex, :client_key_file)
      |> JOSE.JWK.from_pem_file()
    iss  = Application.get_env(:auth0_ex, :domain)
    %Joken.Token{}
    |> with_json_module(Poison)
    |> Joken.with_signer(rs256(key))
    |> Joken.with_aud("https://#{iss}")\
  end

  def set_authenticated(conn, claims) do
    conn |> put_private(:absinthe, %{
      context: %{
        login_status: :authenticated,
        claims: claims
    }})
  end

  def set_unauthenticated(conn) do
    conn |> put_private(:absinthe, %{
      context: %{
        login_status: :unauthenticated
    }})
  end

  def set_token_error(conn, error) do
    # we can't respond with a graphql response at this level so mark it so it can be passed into
    # a resolver'
    conn
    |> put_private(:absinthe, %{
      context:
        %{
          login_status: :invalid_token,
          error: error
        }
      })
  end

end
