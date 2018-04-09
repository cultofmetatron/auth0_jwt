defmodule Auth0Jwt.Absinthe.GetProfileTest do
  use FsjsWeb.ConnCase

  alias Auth0Jwt.Absinthe.GetProfile

  describe "GetProfile middleware" do
    setup [:create_loggedin_resolution]
    test "it gets the profile", %{resolution: resolution} do
      res = GetProfile.call(resolution, %{})
      IO.inspect(res)
      assert res.state == :unresolved
      assert res.context |> Map.get(:profile) != nil
    end

    def create_loggedin_resolution(_) do
      resolution = %Absinthe.Resolution{
        context: %{
          login_status:  :authenticated,
          claims: %{
            "at_hash" => "dPbRwQn80B2oQizNZXeG6Q",
            "aud" => "xp3VZ08kXe0Dl7Mo7NIjpwvtI8vM1YVn",
            "email" => "cultofmetatron@aumlogic.com",
            "email_verified" => true,
            "exp" => 1521122984,
            "iat" => 1521086984,
            "iss" => "https://fsjs-dev.auth0.com/",
            "nonce" => "t7X3Hxt.eBPhMnYECabcqNZDvjPhQjDm",
            "sub" => "google-oauth2|105971703011007196422"
          }
        }
      }
      {:ok, resolution: resolution}
    end

  end
end
