defmodule Lunar.Users.Controller do
  alias Lunar.Helpers.Responses

  def index(conn, _params) do
    case Lunar.Users.Repository.list_all() do
      {:ok, users} ->
        Responses.ok(conn, Poison.encode!(users))

      {:error, reason} ->
        case reason do
          :user_not_found -> Responses.not_found(conn, "User not found")
          _ -> Responses.internal_server_error(conn)
        end
    end
  end

  def show(conn, user_id) do
    case Lunar.Users.Repository.find_one(user_id) do
      {:ok, user} ->
        Responses.ok(conn, Poison.encode!(user))

      {:error, reason} ->
        case reason do
          :user_not_found -> Responses.not_found(conn, "User not found")
          _ -> Responses.internal_server_error(conn)
        end
    end
  end

  def create(conn, params) do
    case Lunar.Users.Repository.create_one(params) do
      {:ok, user} ->
        Responses.created(conn, user)

      {:error, changeset} ->
        Responses.with_ecto_errors(conn, 400, changeset)
    end
  end

  def update(conn, user_id, params) do
    case Lunar.Users.Repository.update_one(user_id, params) do
      {:ok, user} ->
        Responses.ok(conn, Poison.encode!(user))

      {:error, changeset} ->
        Responses.with_ecto_errors(conn, 400, changeset)
    end
  end

  def delete(conn, user_id) do
    case Lunar.Users.Repository.delete_one(user_id) do
      {:ok, user} ->
        Responses.ok(conn, Poison.encode!(user))

      {:error, reason} ->
        case reason do
          :user_not_found -> Responses.not_found(conn, "User not found")
          _ -> Responses.internal_server_error(conn)
        end
    end
  end
end
