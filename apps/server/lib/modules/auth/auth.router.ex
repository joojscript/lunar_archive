defmodule Lunar.Auth.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post("/login_attempt", do: Lunar.Auth.Controller.login_attempt(conn, conn.params))

  post("/verify_otp_code", do: Lunar.Auth.Controller.verify_otp_code(conn, conn.params))
end
