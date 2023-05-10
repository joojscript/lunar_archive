defmodule Lunar.Users.Repository do
  @hidden_fields [:__meta__, :id, :email_verified?]

  def list_all do
    Lunar.Repo.all(Lunar.Users.User)
    |> Enum.map(&(Map.drop(&1, @hidden_fields)))
  end

  def find_one(user_id) do
    Lunar.Repo.get(Lunar.Users.User, user_id)
    |> Map.drop(@hidden_fields)
  end

  def create_one(attrs) do
    Lunar.Users.User.changeset(%Lunar.Users.User{}, attrs)
    |> Lunar.Repo.insert()
  end
end
