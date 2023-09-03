import Config

config :lettuce, folders_to_watch: ["lib"]

config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE"]
