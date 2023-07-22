defmodule Lunar.Hosts.Controller do
  import Plug.Conn
  alias Lunar.Hosts.Host
  alias Lunar.Hosts.Service
  alias Lunar.Helpers.Responses

  @spec create_host(
          Plug.Conn.t(),
          Host.t()
        ) :: Plug.Conn.t()
  def create_host(conn, params) do
    case Service.create_host(params) do
      {:ok, host} ->
        Responses.generic(conn, 201, Poison.encode!(host))

      {:error, changeset} ->
        Responses.with_ecto_errors(conn, 400, changeset)
    end
  end

  @spec verify_host_attempt(Plug.Conn.t(), host_temporary_identifier: String.t()) :: Plug.Conn.t()
  def verify_host_attempt(conn, params) do
    host_temporary_identifier = params["host_temporary_identifier"]

    if is_nil(host_temporary_identifier) do
      Responses.generic(conn, 400, Poison.encode!(%{error: "Bad request"}))
    end

    case Service.verify_host_attempt(host_temporary_identifier) do
      {:ok, hostname} ->
        Responses.generic(conn, 200, Poison.encode!(%{hostname: hostname}))

      {:error, :host_not_found} ->
        Responses.generic(conn, 404, Poison.encode!(%{error: "Host not found"}))
    end
  end
end
