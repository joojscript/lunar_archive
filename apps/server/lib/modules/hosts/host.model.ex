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

  def valid?(host), do: Vex.valid?(host, validation_rules())

  defp validation_rules,
    do: [
      label: &is_binary/1,
      hostname: [presence: true, format: ~r/^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/],
      user_id: [presence: true, uuid: true]
    ]
end
