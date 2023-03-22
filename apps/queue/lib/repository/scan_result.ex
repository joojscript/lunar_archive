defmodule Lunar.Queue.Repository.ScanResults do
  use SurrealEx.HTTP.Table,
    conn: Lunar.Queue.Repository,
    table: "scan_results"

  @spec get_all!(String.t()) :: {:error, any} | {:found, any} | {:not_found, nil} | {:ok, any}
  def get_all!(id) do
    get(id)
  end

  @spec insert_one!(Services.ScanResult) :: {:create, any} | {:error, any} | {:ok, any}
  def insert_one!(params) do
    create(params)
  end
end
