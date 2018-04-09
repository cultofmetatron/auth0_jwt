defmodule Auth0Jwt.Schema.Auth0User do
  @moduledoc """
    here we will define several macros for injecting auth0 user behavior

  """
  defmacro auth0_columns do
    quote do
      field :auth0_id, :string, unique: true
      field :email, :string, unique: true
    end
  end

  @doc """
  auth0 changeset takes a

  """
  def changesets do
    quote do
      def auth0_validate(user) do
        user
        |> validate_required([:auth0_id, :email])
        |> unique_constraint(:auth0_id)
        |> unique_constraint(:email)
      end
    end
  end

  @doc """
  Used to inject the appropriate behavior
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end



end
