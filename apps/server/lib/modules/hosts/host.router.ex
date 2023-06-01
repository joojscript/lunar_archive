defmodule Lunar.Hosts.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post("/verify_host/:host_temporary_identifier",
    do: Lunar.Hosts.Controller.verify_host_attempt(conn, conn.params)
  )
end
