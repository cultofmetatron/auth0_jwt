defmodule Auth0JwtTest do
  use ExUnit.Case
  doctest Auth0Jwt

  test "greets the world" do
    assert Auth0Jwt.hello() == :world
  end
end
