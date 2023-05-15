defmodule Lunar.Helpers.Random do
  def generate_otp_code() do
    :crypto.strong_rand_bytes(3)
    |> Base.encode16()
    |> String.slice(0..5)
  end
end
