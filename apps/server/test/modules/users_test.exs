defmodule Lunar.UsersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @created_user %{}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lunar.Repo)

    created_user = Lunar.Repo.insert!(%Lunar.Users.User{first_name: "John", last_name: "Doe", email: "johndoe@gmail.com"})

    {:ok, %{created_user: created_user}}
  end

  describe "/users" do
    test "GET /users - returns a list of users" do
      conn = conn(:get, "/users")

      response = Lunar.Router.call(conn, %{})

      assert response.status == 200
    end

    test "GET /users/:id - returns a user", %{created_user: created_user} do
      conn = conn(:get, "/users/#{created_user.id}")

      %{
        status: response_status,
        resp_body: response_body
      } = Lunar.Router.call(conn, %{})

      response_body = response_body |> Poison.decode!()

      assert response_status == 200
      assert response_body == %{
        "first_name" => "John",
        "last_name" => "Doe",
        "email" => "johndoe@gmail.com",
      }
    end

    test "POST /users - creates a user" do
      conn = conn(:post, "/users", %{first_name: "Jane", last_name: "Doe", email: "janedoe@gmail.com"})

      %{
        status: response_status,
        resp_body: response_body
      } = Lunar.Router.call(conn, %{})

      response_body = response_body |> Poison.decode!()

      assert response_status == 200
      assert response_body == %{
        "first_name" => "Jane",
        "last_name" => "Doe",
        "email" => "janedoe@gmail.com"
      }
    end

    test "POST /users - returns an error if the user is invalid" do
      conn = conn(:post, "/users", %{first_name: "Jane", last_name: "Doe", email: ""})

      %{
        status: response_status,
        resp_body: response_body
      } = Lunar.Router.call(conn, %{})

      response_body = response_body |> Poison.decode!()

      assert response_status == 400
      assert response_body == %{
        "email" => "Can't be blank"
      }
    end

    test "PUT /users/:id - updates a user", %{created_user: created_user} do
      conn = conn(:put, "/users/#{created_user.id}", %{first_name: "Jane", last_name: "Doe", email: "janedoe@gmail.com"})

      %{
        status: response_status,
        resp_body: response_body
      } = Lunar.Router.call(conn, %{})

      response_body = response_body |> Poison.decode!()

      assert response_status == 200

      assert response_body == %{
        "first_name" => "Jane",
        "last_name" => "Doe",
        "email" => "janedoe@gmail.com"
      }
    end

    test "DELETE /users/:id - deletes a user", %{created_user: created_user} do
      conn = conn(:delete, "/users/#{created_user.id}")

      %{
        status: response_status,
        resp_body: response_body
      } = Lunar.Router.call(conn, %{})

      response_body = response_body |> Poison.decode!()

      assert response_status == 200
      assert response_body == %{
        "first_name" => "John",
        "last_name" => "Doe",
        "email" => "johndoe@gmail.com"
      }
    end
  end
end
