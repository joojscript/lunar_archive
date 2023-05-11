defmodule Lunar.Repo do
  @adapter (
    case Mix.env() do
      :test -> Ecto.Adapters.SQLite3
      _ -> Ecto.Adapters.Postgres
    end
  )

  use Ecto.Repo,
    otp_app: :lunar,
    adapter: @adapter
end
