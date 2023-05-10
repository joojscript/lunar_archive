defmodule Lunar.Test.Repo do
  use Ecto.Repo,
    otp_app: :lunar,
    adapter: Ecto.Adapters.SQLite3
end
