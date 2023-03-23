defmodule Lunar.Repository.Hosts do
  use SurrealEx.HTTP.Table,
    conn: Lunar.Repository,
    table: "hosts"

  @spec get_all :: {:error, any} | {:found, any} | {:not_found, nil} | {:ok, any}
  def get_all() do
    case Lunar.Repository.sql("SELECT hostname FROM hosts") do
      {:ok, response} ->
        {:ok, response.result}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec get_one(String.t()) :: {:error, any} | {:found, any} | {:not_found, nil} | {:ok, any}
  def get_one(id) do
    get(id)
  end
end
