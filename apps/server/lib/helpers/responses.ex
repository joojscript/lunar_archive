defmodule Lunar.Helpers.Responses do
  import Plug.Conn

  alias Lunar.Helpers.Errors

  def generic(conn, 200, body), do: generic(conn, 200, body)
  def generic(conn, 201, body), do: generic(conn, 201, body)
  def generic(conn, 400, body), do: generic(conn, 400, body)
  def generic(conn, 404, body), do: generic(conn, 404, body)

  @spec generic(Plug.Conn.t(), non_neg_integer(), any()) :: Plug.Conn.t()
  def generic(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, body)
  end

  def with_ecto_errors(conn, 400, body), do: with_ecto_errors(conn, 400, body)

  @spec with_ecto_errors(Plug.Conn.t(), non_neg_integer(), Ecto.Changeset.t()) :: Plug.Conn.t()
  def with_ecto_errors(conn, status, changeset) do
    error_map = Errors.format_ecto_changeset_errors(changeset)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, error_map)
  end
end
