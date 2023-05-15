defmodule Lunar.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  forward "/users", to: Lunar.Users.Router

  forward "/auth", to: Lunar.Auth.Router

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
