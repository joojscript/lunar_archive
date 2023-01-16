defmodule Lunar.Repo do
  use Mongo.Repo,
    otp_app: :lunar,
    topology: :mongo

  def generate_child_schema do
    Lunar.Repo.config()
    |> Keyword.merge(url: System.get_env("DATABASE_URL"))
  end
end
