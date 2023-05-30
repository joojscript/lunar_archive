defmodule Lunar.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)

    has_many(:hosts, Lunar.Hosts.Host, foreign_key: :owner_id)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
