defmodule Lunar.Users.Controller do
  import Plug.Conn

  def index(conn, _params) do
    case Lunar.Users.Repository.list_all() do
      {:ok, users} ->
        send_resp(conn, 200, users |> Poison.encode!())

      {:error, reason} ->
        case reason do
          :user_not_found -> send_resp(conn, 404, "User not found")
          _ -> send_resp(conn, 500, "Internal server error")
        end
    end
  end

  def show(conn, user_id) do
    case Lunar.Users.Repository.find_one(user_id) do
      {:ok, user} ->
        send_resp(conn, 200, user |> Poison.encode!())

      {:error, reason} ->
        case reason do
          :user_not_found -> send_resp(conn, 404, "User not found")
          _ -> send_resp(conn, 500, "Internal server error")
        end
    end
  end

  def create(conn, params) do
    case Lunar.Users.Repository.create_one(params) do
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

  def update(conn, user_id, params) do
    case Lunar.Users.Repository.update_one(user_id, params) do
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

  def delete(conn, user_id) do
    case Lunar.Users.Repository.delete_one(user_id) do
      {:ok, user} ->
        send_resp(conn, 200, user |> Poison.encode!())

      {:error, reason} ->
        case reason do
          :user_not_found -> send_resp(conn, 404, "User not found")
          _ -> send_resp(conn, 500, "Internal server error")
        end
    end
  end
end
