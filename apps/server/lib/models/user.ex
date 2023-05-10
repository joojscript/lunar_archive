defmodule Lunar.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :email_verified?, :boolean, default: false, source: :is_email_verified
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :inserted_at, :updated_at])
    |> validate_required([:first_name, :last_name, :email, :inserted_at, :updated_at])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
