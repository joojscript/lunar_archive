defmodule Lunar.Repo.Migrations.CreateHosts do
  use Ecto.Migration

  def change do
    create table(:hosts, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:label, :string, null: true)
      add(:hostname, :string, null: false)
      add(:verified_at, :utc_datetime, null: true, default: fragment("now()"))
      add(:user_id, references(:users, type: :binary_id), null: false)

      timestamps(default: Lunar.Helpers.Repo.timestamps_default_fragment())
    end

    create(index(:hosts, [:hostname], unique: true))
  end
end
