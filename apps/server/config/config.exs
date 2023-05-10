import Config

config :lunar, ecto_repos: [Lunar.Repo]

env_specific_file = Path.join(__DIR__, "#{Mix.env}.exs")
env_specific_secret_file = Path.join(__DIR__, "#{Mix.env}.secret.exs")

if File.exists?(env_specific_file) do
  import_config env_specific_file
end

if File.exists?(env_specific_secret_file) do
  import_config env_specific_secret_file
end
