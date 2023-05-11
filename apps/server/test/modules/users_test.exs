defmodule Lunar.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @created_user %{}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lunar.Repo)

    @created_user = Lunar.Repo.insert!(%Lunar.Users.User{first_name: "John", last_name: "Doe", email: "johndoe@gmail.com"})

    :ok
  end

  describe "GET /users" do
    test "returns a list of users" do
      conn = conn(:get, "/users")

      response = Lunar.Router.call(conn, %{})

      assert response.status == 200
    end
  end
end
