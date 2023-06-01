defmodule Lunar.Users.Repository do
  @hidden_fields [:__meta__, :id, :email_verified?, :hosts]
  @hidden_fields_without_id [:__meta__, :email_verified?, :hosts]

  def list_all do
    case Lunar.Repo.all(Lunar.Users.User) do
      users ->
        {
          :ok,
          users |> Enum.map(&Map.drop(&1, @hidden_fields))
        }

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_one(user_id) do
    case Lunar.Repo.get(Lunar.Users.User, user_id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user |> Map.drop(@hidden_fields)}
    end
  end

  def find_one_by(by, value) do
    case Lunar.Repo.get_by(Lunar.Users.User, [{by, value}]) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user |> Map.drop(@hidden_fields_without_id)}
    end
  end

  def create_one(attrs) do
    case Lunar.Users.User.changeset(%Lunar.Users.User{}, attrs) |> Lunar.Repo.insert() do
      {:ok, user} -> {:ok, user |> Map.drop(@hidden_fields_without_id)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_one(user_id, attrs) do
    case Lunar.Repo.get(Lunar.Users.User, user_id) do
      user ->
        case Lunar.Users.User.changeset(user, attrs) |> Lunar.Repo.update() do
          {:ok, user} -> {:ok, user |> Map.drop(@hidden_fields)}
          {:error, changeset} -> {:error, changeset}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def delete_one(user_id) do
    case Lunar.Repo.get(Lunar.Users.User, user_id) do
      nil ->
        {:error, :user_not_found}

      user ->
        case Lunar.Repo.delete(user) do
          {:ok, user} -> {:ok, user |> Map.drop(@hidden_fields)}
          {:error, reason} -> {:error, reason}
        end
    end
  end
end
