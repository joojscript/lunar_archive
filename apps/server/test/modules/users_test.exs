defmodule Lunar.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Lunar.Test.Repo

  @created_user %{}

  setup do
    @created_user = Repo.insert!(%Lunar.Users.User{first_name: "John", last_name: "Doe", email: "johndoe@gmail.com"})
  end

  describe "GET /users" do
    test "returns a list of users" do
      conn = conn(:get, "/users")

      response = Lunar.Router.call(conn, %{})

      assert response.status == 200
    end
  end
end
