defmodule Auth0Jwt.Migrations do
  defmacro auth0_user_columns(table_name) do
    quote do
      alter table(unquote(table_name)) do
        add :auth0_id, :string
        add :email, :string
      end

      create unique_index(:users, [:auth0_id])
      create unique_index(:users, [:email])
    end
  end
end
