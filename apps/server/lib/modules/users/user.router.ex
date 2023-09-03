defmodule Lunar.Users.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/", do: Lunar.Users.Controller.index(conn, %{}))

  get("/:user_id", do: Lunar.Users.Controller.show(conn, user_id))

  post("/", do: Lunar.Users.Controller.create(conn, conn.params))

  put("/:user_id", do: Lunar.Users.Controller.update(conn, user_id, conn.params))

  delete("/:user_id", do: Lunar.Users.Controller.delete(conn, user_id))
end
