defmodule FourcastersApiClient.PollOrderBookActor do
  use GenServer

  alias FourcastersApiClient.ApiClient
  alias FourcastersApiClient.GameCache

  @poll_interval System.get_env("FOURCASTERS_POLL_INTERVAL") || 6000
  @username System.get_env("FOURCASTERS_API_USERNAME")
  @password System.get_env("FOURCASTERS_API_PASSWORD")

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    IO.puts("username #{@username} password #{@password}")

    # Login with the API credentials from environment variables and start polling the orderbook
    case ApiClient.login(@username, @password) do
      {:ok, auth_token} ->
        IO.puts("Login successful: #{auth_token}")
        # Get the initial orderbook and process the games
        orderbook = get_orderbook(auth_token)
        Enum.each(orderbook, &process_game/1)
        # Send a message to poll the orderbook periodically
        Process.send_after(self(), :poll_orderbook, @poll_interval)
        {:ok, %{auth_token: auth_token}}

      {:error, error} ->
        IO.puts("Failed to login: #{error}")
        {:stop, error}
    end
  end

  def handle_info(:poll_orderbook, state) do
    auth_token = state.auth_token
    # Get the latest orderbook and process the games
    orderbook = get_orderbook(auth_token)
    Enum.each(orderbook, &process_game/1)
    # Send a message to poll the orderbook periodically
    Process.send_after(self(), :poll_orderbook, @poll_interval)
    {:noreply, state}
  end

  defp get_orderbook(auth_token) do
    # Fetch the orderbook from the API and extract the games
    {:ok, orderbook} = ApiClient.get_orderbook(auth_token, "mlb")
    orderbook["data"]["games"]
  end

  defp process_game(game) do
    # Extract game information from the API response and process it
    id = game["id"]
    away_team_id = game["participants"] |> Enum.at(0) |> Map.get("id")
    away_rotation_number = game["participants"] |> Enum.at(0) |> Map.get("rotationNumber")
    home_team_id = game["participants"] |> Enum.at(1) |> Map.get("id")
    home_rotation_number = game["participants"] |> Enum.at(1) |> Map.get("rotationNumber")

    best_home_moneyline_price =
      case game["homeMoneylines"] do
        [] -> nil
        lines -> lines |> List.first() |> Map.get("odds")
      end

    best_away_moneyline_price =
      case game["awayMoneylines"] do
        [] -> nil
        lines -> lines |> List.first() |> Map.get("odds")
      end

    game_data = %{
      id: id,
      home_team_id: home_team_id,
      away_team_id: away_team_id,
      away_rotation_number: away_rotation_number,
      home_rotation_number: home_rotation_number,
      best_home_moneyline_price: best_home_moneyline_price,
      best_away_moneyline_price: best_away_moneyline_price,
    }

    # Add the game data to the cache
    FourcastersApiClient.GameCache.add_game(game_data)
  end
end
