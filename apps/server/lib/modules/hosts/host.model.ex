defmodule Lunar.Hosts.Host do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "hosts" do
    field(:label, :string)
    field(:hostname, :string)

    belongs_to(:user, Lunar.Users.User, type: :binary_id)
  end

  def changeset(host, attrs) do
    host
    |> cast(attrs, [:label, :hostname, :user_id])
    |> validate_required([:hostname, :user_id])
  end
end
