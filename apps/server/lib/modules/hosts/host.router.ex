defmodule Lunar.Hosts.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post("/", do: Lunar.Hosts.Controller.create_host(conn, conn.params))

  post("/verify-host/:host_temporary_identifier",
    do: Lunar.Hosts.Controller.verify_host_attempt(conn, conn.params)
  )
end
