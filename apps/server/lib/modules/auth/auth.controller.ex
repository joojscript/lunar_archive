defmodule Lunar.Auth.Controller do
  import Plug.Conn

  alias Lunar.Registry
  alias Lunar.Helpers.Responses

  def login_attempt(conn, params) do
    case Lunar.Auth.Service.send_login_otp_code(params) do
      {:ok, user} ->
        Responses.created(conn, Poison.encode!(user))

      {:error, changeset} ->
        Responses.with_ecto_errors(conn, 400, changeset)
    end
  end

  def verify_otp_code(conn, params) do
    case Lunar.Auth.Service.verify_otp_code(params) do
      {:ok, user} ->
        with {:ok, session_id} <- create_session_for_user(user) do
          Responses.ok(conn, Poison.ecode!(%{verified: true, user: user, session_id: session_id}))
        else
          {:error, reason} ->
            Responses.bad_request(conn, Poison.encode!(%{verified: false, reason: reason}))
        end

      {:error, reason} ->
            Responses.bad_request(conn, Poison.encode!(%{verified: false, reason: reason}))
    end
  end

  def create_session_for_user(user) do
    Registry.SessionManager.create_session(user)
  end
end
