import Config

config :surreal_ex, Lunar.Queue.Repository,
  interface: :http,
  uri: "http://192.168.0.114:8002",
  ns: "lunar",
  db: "lunar",
  user: "root",
  pass: "root"
