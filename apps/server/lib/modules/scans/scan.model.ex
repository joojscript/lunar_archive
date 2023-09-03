defmodule Lunar.Scans.Scan do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lunar.Helpers.Errors

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "scans" do
    field(:results, :map)
    belongs_to(:host, Lunar.Hosts.Host)
    timestamps()
  end

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(scan, attrs) do
    scan
    |> cast(attrs, [:results, :host_id])
    |> validate_required([:results, :host_id])
  end

  def valid?(scan) do
    cond do
      Vex.valid?(scan, validation_rules()) ->
        {:ok, true}

      true ->
        validation_errors = Vex.errors(scan, validation_rules())
        changeset_errors = Errors.vex_errors_to_changeset_errors(validation_errors)
        {:error, changeset(%{errors: changeset_errors})}
    end
  end

  defp validation_rules,
    do: [
      host_id: [presence: true, uuid: true],
      results: [presence: true, map: true]
    ]
end
