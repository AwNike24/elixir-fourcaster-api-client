defmodule FourcastersApiClient.GameCache do
  use GenServer

  ## API

  # Starts the GenServer and initializes the state
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Adds a game to the state
  def add_game(game) do
    GenServer.call(__MODULE__, {:add_game, game})
  end

  # Returns the list of games in the state
  def get_games do
    GenServer.call(__MODULE__, :get_games)
  end

  ## GenServer callbacks

  # Initializes the state
  def init(_) do
    {:ok, %{}}
  end

  # Handles messages to add or get games
  def handle_call({:add_game, game}, _from, state) do
    id = game[:id]
    case Map.get(state, id) do
      nil ->
        # Add the game to the state
        new_state = Map.put(state, id, game)
        {:reply, :ok, new_state}

      existing_game ->
        # Compare the moneyline prices and update the cache if necessary
        if existing_game[:best_home_moneyline_price] != game[:best_home_moneyline_price] do
          IO.puts "Home Team Id price for game #{id} changed from #{existing_game[:best_home_moneyline_price]} to #{game[:best_home_moneyline_price]}"
        end

        if existing_game[:best_away_moneyline_price] != game[:best_away_moneyline_price] do
          IO.puts "Away Team Id price for game #{id} changed from #{existing_game[:best_away_moneyline_price]} to #{game[:best_away_moneyline_price]}"
        end

        # Update the game data in the state
        new_state = Map.put(state, id, game)
        {:reply, :ok, new_state}
    end
  end

  def handle_call(:get_games, _from, state) do
    {:reply, Map.values(state), state}
  end
end
