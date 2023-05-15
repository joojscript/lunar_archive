defmodule Lunar.AuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Lunar.Registry.SessionManager

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lunar.Repo)

    created_user =
      Lunar.Repo.insert!(%Lunar.Users.User{
        first_name: "John",
        last_name: "Doe",
        email: "joaoaugustoperin@gmail.com"
      })

    session_manager_pid = SessionManager.start_link()

    {:ok,
     %{
       created_user: created_user,
       session_manager_pid: session_manager_pid
     }}
  end

  describe "/auth" do
    test "POST /auth/login_attempt" do
      conn = conn(:post, "/auth/login_attempt", %{email: "joaoaugustoperin@gmail.com"})

      response = Lunar.Router.call(conn, %{})

      assert response.status == 200
    end

    test "POST /auth/verify_otp_code" do
      conn =
        conn(:post, "/auth/verify_otp_code", %{
          email: "joaoaugustoperin@gmail.com",
          otp_code: "123456"
        })

      response = Lunar.Router.call(conn, %{})

      assert response.status == 400 || response.status == 200
    end
  end
end
