import Config

config :lunar, ecto_repos: [Lunar.Repo]

config :lunar, Lunar.Repo,
  database: "/tmp/lunar_test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox
