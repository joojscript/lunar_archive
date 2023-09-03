defmodule Lunar.Helpers.Errors do
  def format_ecto_changeset_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _}} -> {field, String.capitalize(message)} end)
    |> Enum.into(%{})
    |> Poison.encode!()
  end

  def vex_errors_to_changeset_errors(vex_errors) do
    vex_errors
    |> Enum.reduce(%{}, fn {:error, field, _property, message}, acc ->
      Map.put(
        acc,
        field,
        (acc[field] || []) ++ [String.capitalize(message)]
      )
    end)
    |> Map.to_list()
  end
end
