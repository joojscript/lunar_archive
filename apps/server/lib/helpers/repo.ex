defmodule Lunar.Helpers.Repo do
  import Ecto.Migration

  @doc """
  Returns the fragment for each environment to get the default value of the timestamps
  (not anymore supported by Ecto 3).

  In test environment, with SQLite3, we use the DATE function to get the current date without the time.
  On the other environments, with PostgreSQL, we use the now() function.

  # Examples

    # In test environment:
    iex> Lunar.Helpers.Repo.timestamps_default_fragment()
    {:fragment, "CURRENT_TIMESTAMP"}

  """
  def timestamps_default_fragment do
    default_function_fragment = case Mix.env() do
      :test -> fragment("CURRENT_TIMESTAMP")
      _ -> fragment("now()")
    end

    default_function_fragment
  end
end
