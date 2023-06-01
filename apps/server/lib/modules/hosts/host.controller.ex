defmodule Lunar.Hosts.Controller do
  @spec verify_host_attempt(Plug.Conn.t(), host_temporary_identifier: String.t()) :: Plug.Conn.t()
  def verify_host_attempt(conn, host_temporary_identifier)
      when not is_nil(host_temporary_identifier) do
    IO.inspect(host_temporary_identifier)
    conn
  end
end
