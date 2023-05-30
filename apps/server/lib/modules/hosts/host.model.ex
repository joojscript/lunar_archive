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
    |> cast(attrs, [:label, :hostname, :owner_id])
    |> validate_required([:hostname, :owner_id])
  end
end
