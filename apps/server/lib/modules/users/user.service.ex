defmodule Lunar.Users.Service do
  import Ecto.Query, only: [from: 2]

  def create_user(attrs) do
    Lunar.Users.Repository.create_one(attrs)
  end
end
