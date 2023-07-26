defmodule Lunar.Helpers.Responses do
  import Plug.Conn

  alias Lunar.Helpers.Errors

  def generic(conn, 200, body), do: generic(conn, 200, body)
  def generic(conn, 201, body), do: generic(conn, 201, body)
  def generic(conn, 400, body), do: generic(conn, 400, body)
  def generic(conn, 404, body), do: generic(conn, 404, body)

  def generic(conn, status, body) when is_binary(body),
    do: generic(conn, status, %{message: body})

  @spec generic(Plug.Conn.t(), non_neg_integer(), any()) :: Plug.Conn.t()
  def generic(conn, status, body) when is_map(body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Poison.encode!(body))
    |> halt()
  end

  @spec with_ecto_errors(Plug.Conn.t(), non_neg_integer(), Ecto.Changeset.t()) :: Plug.Conn.t()
  def with_ecto_errors(conn, status, changeset) do
    error_map = Errors.format_ecto_changeset_errors(changeset)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, error_map)
    |> halt()
  end

  def bad_request(conn), do: generic(conn, 400, "Bad Request")
  def bad_request(conn, body), do: generic(conn, 400, body)

  def not_found(conn), do: generic(conn, 404, "Not Found")
  def not_found(conn, body), do: generic(conn, 404, body)

  def internal_server_error(conn), do: generic(conn, 500, "Internal Server Error")
  def internal_server_error(conn, body), do: generic(conn, 500, body)

  def ok(conn, body), do: generic(conn, 200, body)
  def created(conn, body), do: generic(conn, 201, body)
end
