defmodule Lunar.Hosts.Repository do
  alias Lunar.Hosts.Host

  @hidden_fields [:__meta__, :id, :user]
  @hidden_fields_without_id [:__meta__, :user]

  def list_all do
    case Lunar.Repo.all(Host) do
      {:error, reason} ->
        {:error, reason}

      hosts ->
        {
          :ok,
          hosts |> Enum.map(&Map.drop(&1, @hidden_fields))
        }
    end
  end

  def find_one(host_id) do
    case Lunar.Repo.get(Host, host_id) do
      nil -> {:error, :host_not_found}
      host -> {:ok, host |> Map.drop(@hidden_fields)}
    end
  end

  def find_one_by(by, value) do
    case Lunar.Repo.get_by(Host, [{by, value}]) do
      nil -> {:error, :host_not_found}
      host -> {:ok, host |> Map.drop(@hidden_fields_without_id)}
    end
  end

  @spec create_one(Host.t()) :: {:error, any} | {:ok, Host.t()}
  def create_one(attrs) when not is_nil(attrs) do
    changeset = Host.changeset(%Host{}, attrs)

    case Host.valid?(attrs) do
      {:ok, true} ->
        case Lunar.Repo.insert(changeset) do
          {:ok, host} -> {:ok, host |> Map.drop(@hidden_fields_without_id)}
          {:error, changeset} -> {:error, changeset}
        end

      {:error, errors} ->
        {:error, errors}
    end
  end

  def create_one(attrs) when is_nil(attrs), do: create_one(%{})

  def update_one(host_id, attrs) do
    case Lunar.Repo.get(Host, host_id) do
      {:error, reason} ->
        {:error, reason}

      host ->
        case Host.changeset(host, attrs) |> Lunar.Repo.update() do
          {:ok, host} -> {:ok, host |> Map.drop(@hidden_fields)}
          {:error, changeset} -> {:error, changeset}
        end
    end
  end

  def delete_one(host_id) do
    case Lunar.Repo.get(Host, host_id) do
      nil ->
        {:error, :host_not_found}

      host ->
        case Lunar.Repo.delete(host) do
          {:ok, host} -> {:ok, host |> Map.drop(@hidden_fields)}
          {:error, reason} -> {:error, reason}
        end
    end
  end
end
