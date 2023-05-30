defmodule Lunar.Plugs.Authentication do
  import Plug.Conn

  alias Lunar.Registry.SessionManager

  def init(opts), do: opts

  def call(conn, _opts) do
    headers = Enum.into(conn.req_headers, %{})
    authorization_header = headers["authorization"] || headers["Authorization"]
    token = extract_token(authorization_header)

    case SessionManager.retrieve_session_from_session_id(token) do
      [{_, user}] ->
        assign(conn, :current_user, user)

      _ ->
        send_resp(conn, 401, "Unauthorized")
    end
  end

  defp extract_token(authorization_header) when not is_nil(authorization_header) do
    case String.split(authorization_header, " ") do
      ["Bearer", token] ->
        token

      _ ->
        nil
    end
  end

  defp extract_token(_), do: nil
end
