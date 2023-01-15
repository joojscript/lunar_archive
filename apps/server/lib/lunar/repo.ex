defmodule Lunar.Repo do
  use Ecto.Repo,
    otp_app: :lunar,
    adapter: Ecto.Adapters.Postgres
end
