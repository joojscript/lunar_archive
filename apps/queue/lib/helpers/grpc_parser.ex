defmodule Lunar.Queue.Helpers.Grpc.Parser do
  @behaviour Protobuf.TransformModule

  @spec redact_fields :: [:__struct__ | :__unknown_fields__]
  defp redact_fields, do: [:__unknown_fields__, :__struct__]

  @doc """
    Converts a binary to a typed struct.

    ## Examples

      iex> binary = "{\\"ports\\":[],\\"hostname\\":\\"192.168.0.114\\"}"
      iex> Lunar.Queue.Helpers.Grpc.Parser.encode(binary, Lunar.Queue.Services.ScanRequest)
      %Lunar.Queue.Services.ScanRequest{action: :SAVE, hostname: "", ports: []}
  """
  @impl true
  @spec encode(iodata, atom | struct) :: struct
  def encode(string, type) when is_binary(string) do
    struct(
      type,
      Poison.decode!(string)
    )
  end

  @doc """
    Converts a struct to a binary.

    ## Examples

      iex> struct = %Lunar.Queue.Services.ScanRequest{hostname: "192.168.0.114"}
      iex> Lunar.Queue.Helpers.Grpc.Parser.decode(struct)
      "{\\"ports\\":[],\\"hostname\\":\\"192.168.0.114\\",\\"action\\":\\"SAVE\\",\\"__unknown_fields__\\":[]}"
  """
  @impl true
  @spec decode(any, any) ::
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
  def decode(_struct, map), do: Poison.encode!(map)

  @doc """
    Converts a struct to a map.
    Removes the redacted fields, making it easier to work with.

    ## Examples

      iex> struct = %Lunar.Queue.Services.ScanRequest{hostname: "192.168.0.114"}
      iex> Lunar.Queue.Helpers.Grpc.Parser.decode(struct)
      "{\\"ports\\":[],\\"hostname\\":\\"192.168.0.114\\",\\"action\\":\\"SAVE\\",\\"__unknown_fields__\\":[]}"
  """
  @spec decode(map) ::
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
  def decode(map) when is_map(map), do: Poison.encode!(map)

  @doc """
    Converts a map to a typed struct.
    Removes the redacted fields, making it easier to work with.
    Removes __struct__, thus, it won't be recognized as a typed Struct anymrore.

    ## Examples

      iex> map = %{"hostname" => "192.168.0.114"}
      iex> Lunar.Queue.Helpers.Grpc.Parser.map_to_typed_struct(map, %Lunar.Queue.Services.ScanRequest{})
      %{action: :SAVE, hostname: "192.168.0.114", ports: []}
  """
  @spec map_to_typed_struct(map, atom) :: struct
  def map_to_typed_struct(map, base_struct) do
    map_with_atom_keys =
      for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}

    intermediate_struct =
      struct(
        base_struct,
        map_with_atom_keys
      )

    Map.drop(intermediate_struct, redact_fields())
  end
end
