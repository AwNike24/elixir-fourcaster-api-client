defmodule FourcastersApiClient.LoginActor do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
  end

  def login(pid) do
    GenServer.call(pid, :login)
  end

  def handle_call(:login, _from, state) do
    # Add your login logic here. For example:
    # {:ok, token} = FourcastersApiClient.ApiClient.login("username", "password")

    # You may want to update the state with the token or any other relevant information.
    # new_state = Map.put(state, :token, token)

    Logger.info("Logged in successfully")
    {:reply, :ok, state} # Replace 'state' with 'new_state' if you updated the state
  end
end
