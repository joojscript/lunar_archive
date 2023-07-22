defmodule Lunar.Users.Service do
  def create_user(attrs) do
    Lunar.Users.Repository.create_one(attrs)
  end
end
