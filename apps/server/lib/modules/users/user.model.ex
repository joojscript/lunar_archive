defmodule Lunar.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)

    has_many(:hosts, Lunar.Hosts.Host, foreign_key: :user_id)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def valid?(user), do: Vex.valid?(user, validation_rules())

  defp validation_rules,
    do: [
      first_name: &is_binary/1,
      last_name: &is_binary/1,
      email: [presence: true, format: ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/]
    ]
end
