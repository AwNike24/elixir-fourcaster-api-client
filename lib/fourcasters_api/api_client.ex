defmodule FourcastersApiClient.ApiClient do
  require HTTPoison
  require Logger
  alias HTTPoison.Response, as: Response

  @login_url "https://api.4casters.io/user/login"
  @orderbook_url "https://api.4casters.io/exchange/v2/getOrderbook"

  def login(username, password) do
    headers = [      {"Content-Type", "application/json"},      {"Accept", "application/json"}    ]

    body = %{
             "username" => username,
             "password" => password
           }
           |> Poison.encode!()

    Logger.info("Sending login request...")

    case HTTPoison.post(@login_url, body, headers) do
      {:ok, %Response{status_code: 200, body: body}} ->
        response_body = Poison.decode!(body)
        auth_token = response_body["data"]["user"]["auth"]
        Logger.info("Login successful: #{inspect(response_body)}")
        {:ok, auth_token}

      {:ok, %Response{status_code: status_code}} ->
        Logger.error("Login failed. Status code: #{status_code}")
        {:error, "Login failed. Status code: #{status_code}"}

      {:error, error} ->
        Logger.error("Login request failed. Error: #{inspect(error)}")
        {:error, "Login request failed. Error: #{inspect(error)}"}
    end
  end

  def get_orderbook(auth_token, league) do
    headers = [
      {"Authorization", auth_token}
    ]

    url = "#{@orderbook_url}?league=#{league}"

    Logger.info("Sending getOrderbook request...")

    case HTTPoison.get(url, headers) do
      {:ok, %Response{status_code: 200, body: body}} ->
        Logger.info("getOrderbook successful")
        {:ok, Poison.decode!(body)}

      {:ok, %Response{status_code: status_code}} ->
        Logger.error("getOrderbook failed. Status code: #{status_code}")
        {:error, "getOrderbook failed. Status code: #{status_code}"}

      {:error, error} ->
        Logger.error("getOrderbook request failed. Error: #{inspect(error)}")
        {:error, "getOrderbook request failed. Error: #{inspect(error)}"}
    end
  end
end
