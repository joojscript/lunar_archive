defmodule Lunar.Hosts.Controller do
  import Plug.Conn
  alias Lunar.Hosts.Host
  alias Lunar.Hosts.Service
  alias Lunar.Helpers.Errors

  @spec create_host(
          Plug.Conn.t(),
          Host.t()
        ) :: Plug.Conn.t()
  def create_host(conn, params) do
    case Service.create_host(params) do
      {:ok, host} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, Poison.encode!(host))

      {:error, changeset} ->
        errors_map = Errors.format_ecto_changeset_errors(changeset)

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(400, errors_map)
    end
  end

  @spec verify_host_attempt(Plug.Conn.t(), host_temporary_identifier: String.t()) :: Plug.Conn.t()
  def verify_host_attempt(conn, params) do
    host_temporary_identifier = params["host_temporary_identifier"]

    if is_nil(host_temporary_identifier) do
      send_resp(conn, 400, "Bad request")
    end

    case Service.verify_host_attempt(host_temporary_identifier) do
      {:ok, hostname} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(200, Poison.encode!(%{hostname: hostname}))

      {:error, :host_not_found} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(404, Poison.encode!(%{error: "Host not found"}))
    end
  end
end
