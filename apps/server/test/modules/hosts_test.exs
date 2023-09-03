defmodule Lunar.HostsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lunar.Repo)

    created_user =
      Lunar.Repo.insert!(%Lunar.Users.User{
        first_name: "John",
        last_name: "Doe",
        email: "johndoe@gmail.com"
      })

    {:ok, %{created_user: created_user}}
  end

  test "POST /hosts/verify_host/:host_temporary_identifier - verifies a host" do
    conn =
      conn(:post, "/hosts/verify_host/123", %{})

    %{
      status: response_status,
      resp_body: response_body
    } = Lunar.Router.call(conn, %{})

    assert response_status == 404
  end

  test "POST /hosts - [invalid payload] does not creates a host" do
    conn =
      conn(:post, "/hosts", %{})

    %{
      status: response_status,
      resp_body: response_body
    } = Lunar.Router.call(conn, %{})

    response_body = Poison.decode!(response_body)

    assert response_status == 400

    assert response_body == %{"hostname" => "Can't be blank", "user_id" => "Can't be blank"}
  end

  test "POST /hosts - [valid payload] creates a host", context do
    payload = %{
      "hostname" => "test-hostname",
      "label" => "my-host",
      "user_id" => context.created_user.id
    }

    conn =
      conn(
        :post,
        "/hosts",
        payload
      )

    %{
      status: response_status,
      resp_body: response_body
    } = Lunar.Router.call(conn, %{})

    response_body = Poison.decode!(response_body) |> Map.delete("id")

    assert response_status == 201
    assert response_body == payload
  end
end
