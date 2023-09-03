defmodule Lunar.Repo.Migrations.CreateScans do
  use Ecto.Migration

  def change do
    create table(:scans, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:results, :map, null: false)
      add(:host_id, references(:hosts, type: :binary_id), null: false)

      timestamps(default: Lunar.Helpers.Repo.timestamps_default_fragment())
    end
  end
end
