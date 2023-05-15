defmodule Lunar.Users.Service do
  import Ecto.Query, only: [from: 2]

  def get_user_by(by, value) do
    case Lunar.Repo.get_by(Lunar.Users.User, [{by, value}]) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def create_user(attrs) do
    Lunar.Users.Repository.create_one(attrs)
  end
end
