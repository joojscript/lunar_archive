defmodule Lunar.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: true
      add :last_name, :string, null: true
      add :email, :string, null: false
      add :is_email_verified, :boolean, null: false, default: false

      timestamps(default: Lunar.Helpers.Repo.timestamps_default_fragment())
    end

    create index(:users, [:email], unique: true)
  end
end
