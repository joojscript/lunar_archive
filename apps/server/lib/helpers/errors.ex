defmodule Lunar.Helpers.Errors do
  def format_ecto_changeset_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message , _}} -> {field, String.capitalize(message)} end)
    |> Enum.into(%{})
    |> Poison.encode!()
  end
end
