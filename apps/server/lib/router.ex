defmodule Lunar.Router do
  use Plug.Router

  plug(CORSPlug)
  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(Lunar.Plugs.Authentication)
  plug(:dispatch)

  forward("/users", to: Lunar.Users.Router)

  forward("/auth", to: Lunar.Auth.Router)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
