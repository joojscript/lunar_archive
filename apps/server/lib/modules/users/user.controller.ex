defmodule Lunar.Users.Controller do
  import Plug.Conn

  def index(conn, _params) do
    users = Lunar.Users.Repository.list_all()
    send_resp(conn, 200, users |> Poison.encode!())
  end

  def show(conn, user_id) do
    user = Lunar.Users.Repository.find_one(user_id)
    send_resp(conn, 200, user |> Poison.encode!())
  end

  def create(conn, params) do
    Lunar.Users.Repository.create_one(params)
    send_resp(conn, 200, "User created")
  end
end
