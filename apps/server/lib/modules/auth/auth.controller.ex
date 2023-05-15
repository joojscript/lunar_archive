defmodule Lunar.Auth.Controller do
  import Plug.Conn

  alias Lunar.Registry

  def login_attempt(conn, params) do
    case Lunar.Auth.Service.send_login_otp_code(params) do
      {:ok, user} ->
        send_resp(conn, 201, user |> Poison.encode!())

      {:error, changeset} ->
        send_resp(
          conn,
          400,
          changeset |> Lunar.Helpers.Errors.format_ecto_changeset_errors()
        )
    end
  end

  def verify_otp_code(conn, params) do
    case Lunar.Auth.Service.verify_otp_code(params) do
      {:ok, user} ->
        with {:ok, session_id} <- create_session_for_user(user) do
          send_resp(conn, 200, %{verified: true, user: user} |> Poison.encode!())
        else
          {:error, reason} ->
            send_resp(conn, 400, %{verified: false, reason: reason} |> Poison.encode!())
        end

      {:error, reason} ->
        case reason do
          :user_not_found ->
            send_resp(conn, 400, %{verified: false, reason: "user_not_found"} |> Poison.encode!())

          :invalid_otp_code ->
            send_resp(
              conn,
              400,
              %{verified: false, reason: "invalid_otp_code"} |> Poison.encode!()
            )
        end
    end
  end

  def create_session_for_user(user) do
    Registry.SessionManager.create_session(user)
  end
end
