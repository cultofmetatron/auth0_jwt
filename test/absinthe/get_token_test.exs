defmodule Auth0Jwt.Absinthe.GetTokenTest do
  use FsjsWeb.ConnCase

  alias Auth0Jwt.Absinthe.GetToken

  @valid_jwt "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik1rVTJSa0V3TVRrME1EVTNNVFl3UmpFNVJUUXpRMFZCUTBWRE16TkdORVUzUTBWRFJqRXhOdyJ9.eyJlbWFpbCI6ImN1bHRvZm1ldGF0cm9uQGF1bWxvZ2ljLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2ZzanMtZGV2LmF1dGgwLmNvbS8iLCJzdWIiOiJnb29nbGUtb2F1dGgyfDEwNTk3MTcwMzAxMTAwNzE5NjQyMiIsImF1ZCI6InhwM1ZaMDhrWGUwRGw3TW83TklqcHd2dEk4dk0xWVZuIiwiaWF0IjoxNTIxMDg2OTg0LCJleHAiOjE1MjExMjI5ODQsImF0X2hhc2giOiJkUGJSd1FuODBCMm9RaXpOWlhlRzZRIiwibm9uY2UiOiJ0N1gzSHh0LmVCUGhNbllFQ2FiY3FOWkR2alBoUWpEbSJ9.dh_akDJo7kXQLMBwTERURjsn5y7xeLnFNAgPlJ8jpgfFurLPInR5O8_JU0gqH8iD4FArR7E7dE580PuQycUnetg749FdA9juASYdxjtiXsHDeWGpmtfudQRoFbJ_F3LcpvWdO_r-kMx-ADVXoqSnFok8o5NjgzaMHTkx2DmJe70V8EoQZ7SXU-wMWFCW6XUqaloiwYjRNJmYWWkjhbvhr2Ij3QAsZ3ba_HXBxOk1kCh6lhq_NhxtGKRQl5e4EbkMhBxC7NLivplCv7pKhLYkE9_HqDxcKwQMbo6GA4UfVybDQxVYsq_7XNquCHFanT_wEGsaA3wjSOnhv4NYzth4BA"

  describe "GetToken middleware" do
    setup [:set_valid_jwt]
    test "it gets a token from a jwt", %{conn: conn} do
      token = GetToken.get_token(conn)
      assert token == @valid_jwt
    end

    test "its sets the claims on the conn",  %{conn: conn} do
      new_conn = GetToken.call(conn, %{})
      %{private: %{ absinthe: %{ context: context } }} = new_conn
      %{claims: claims } = context
      assert claims["sub"] == "google-oauth2|105971703011007196422"
      assert claims["email"] == "cultofmetatron@aumlogic.com"
    end

  end

  defp set_valid_jwt(%{conn: conn}) do
    {:ok, conn: Plug.Conn.put_req_header(conn, "authorization", "Bearer #{@valid_jwt}")}
  end

end
