defmodule Auth0Jwt.Absinthe.RequireAuthenticatedTest do
  use FsjsWeb.ConnCase

  alias Auth0Jwt.Absinthe.GetToken
  alias Auth0Jwt.Absinthe.RequireAuthenicated

  @valid_jwt "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik1rVTJSa0V3TVRrME1EVTNNVFl3UmpFNVJUUXpRMFZCUTBWRE16TkdORVUzUTBWRFJqRXhOdyJ9.eyJlbWFpbCI6ImN1bHRvZm1ldGF0cm9uQGF1bWxvZ2ljLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2ZzanMtZGV2LmF1dGgwLmNvbS8iLCJzdWIiOiJnb29nbGUtb2F1dGgyfDEwNTk3MTcwMzAxMTAwNzE5NjQyMiIsImF1ZCI6InhwM1ZaMDhrWGUwRGw3TW83TklqcHd2dEk4dk0xWVZuIiwiaWF0IjoxNTIxMDg2OTg0LCJleHAiOjE1MjExMjI5ODQsImF0X2hhc2giOiJkUGJSd1FuODBCMm9RaXpOWlhlRzZRIiwibm9uY2UiOiJ0N1gzSHh0LmVCUGhNbllFQ2FiY3FOWkR2alBoUWpEbSJ9.dh_akDJo7kXQLMBwTERURjsn5y7xeLnFNAgPlJ8jpgfFurLPInR5O8_JU0gqH8iD4FArR7E7dE580PuQycUnetg749FdA9juASYdxjtiXsHDeWGpmtfudQRoFbJ_F3LcpvWdO_r-kMx-ADVXoqSnFok8o5NjgzaMHTkx2DmJe70V8EoQZ7SXU-wMWFCW6XUqaloiwYjRNJmYWWkjhbvhr2Ij3QAsZ3ba_HXBxOk1kCh6lhq_NhxtGKRQl5e4EbkMhBxC7NLivplCv7pKhLYkE9_HqDxcKwQMbo6GA4UfVybDQxVYsq_7XNquCHFanT_wEGsaA3wjSOnhv4NYzth4BA"

  describe "RequireAuthenticated" do
    setup [:create_loggedin_resolution, :create_loggedout_resolution]
    test "returns itself if claims is valid", %{resolution: resolution} do
      res = RequireAuthenicated.call(resolution, %{})
      assert res == resolution
    end

    test "returns a failed result if unauthenticated", %{bad_resolution: resolution} do
      res = RequireAuthenicated.call(resolution, %{})
      assert res.state == :resolved
      assert ["unauthenticated"] == res.errors
      assert res != resolution
    end
  end

  defp create_loggedin_resolution(_) do
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

  def create_loggedout_resolution(_) do
    resolution = %Absinthe.Resolution{
      context: %{
        login_status:  :unauthenticated
      }
    }
    {:ok, bad_resolution: resolution}
  end

end
