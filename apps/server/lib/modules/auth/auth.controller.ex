defmodule Lunar.Auth.Controller do
  import Plug.Conn

  def login_attempt(conn, params) do
    case Lunar.Auth.Service.send_login_otp_code(params) do
      {:ok, user} ->
        send_resp(conn, 200, user |> Poison.encode!())

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
        send_resp(conn, 200, %{verified: true, user: user} |> Poison.encode!())

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
end
