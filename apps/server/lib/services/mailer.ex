defmodule Lunar.Services.Mailer do
  @moduledoc """
  This module is responsible for sending emails.
  """

  use GenServer

  @endpoint_url "https://api.emailjs.com/api/v1.0/email/send"
  @mailer_credentials Application.get_env(:lunar, __MODULE__, [])
  @mailer_user_id Keyword.get(@mailer_credentials, :user_id)
  @mailer_service_id Keyword.get(@mailer_credentials, :service_id)
  @mailer_template_id Keyword.get(@mailer_credentials, :template_id)
  @mailer_access_token Keyword.get(@mailer_credentials, :access_token)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    HTTPoison.start()
    {:ok, opts}
  end

  @spec send({:otp_code, Lunar.Users.User.t(), String.t()}) :: {:ok, HTTPoison.Response.t()}
  def send({:otp_code, user, otp_code}) do
    GenServer.call(__MODULE__, {:otp_code, user, otp_code})
  end

  def handle_call({:otp_code, user, otp_code}, _from, state) do
    data_payload =
      build_payload(%{
        user_first_name: user.first_name,
        otp_code: otp_code,
        send_to: user.email
      })

    request = %HTTPoison.Request{
      url: @endpoint_url,
      method: :post,
      body: data_payload,
      headers: [
        {"Content-Type", "application/json"}
      ]
    }

    # In test environments, do not fire the email sending:
    unless Mix.env() == :test do
      HTTPoison.request(request)
    end

    {:reply, :ok, state}
  end

  defp build_payload(attrs) do
    %{
      user_id: @mailer_user_id,
      service_id: @mailer_service_id,
      template_id: @mailer_template_id,
      accessToken: @mailer_access_token,
      template_params: attrs
    }
    |> Poison.encode!()
  end
end
