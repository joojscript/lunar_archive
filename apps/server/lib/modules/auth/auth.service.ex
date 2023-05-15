defmodule Lunar.Auth.Service do
  def send_login_otp_code(attrs) do
    with {:ok, user} <- Lunar.Users.Repository.find_one_by(:email, attrs["email"]) do
      otp_code = generate_and_save_otp_code(user)
      Lunar.Services.Mailer.send({:otp_code, user, otp_code})
      {:ok, user}
    else
      {:error, _} ->
        with {:ok, user} <- Lunar.Users.Service.create_user(attrs) do
          otp_code = generate_and_save_otp_code(user)
          Lunar.Services.Mailer.send({:otp_code, user, otp_code})
          {:ok, user}
        else
          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  def verify_otp_code(attrs) do
    with {:ok, user} <- Lunar.Users.Repository.find_one_by(:email, attrs["email"]) do
      [{_, otp_code}] = :ets.lookup(:otp_codes, user.id)

      if otp_code == attrs["otp_code"] do
        {:ok, user}
      else
        {:error, :invalid_otp_code}
      end
    else
      _ -> {:error, :user_not_found}
    end
  end

  @spec generate_and_save_otp_code(Lunar.Users.User.t()) :: String.t()
  defp generate_and_save_otp_code(user) do
    otp_code = Lunar.Helpers.Random.generate_otp_code()
    :ets.insert(:otp_codes, {user.id, otp_code})
    otp_code
  end
end
