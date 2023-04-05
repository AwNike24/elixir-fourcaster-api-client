defmodule FourcastersApiClient.Supervisor do
  use Supervisor

  # start_link/1 function to start the supervisor process
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # init/1 function to initialize the supervisor process and its children
  def init(_) do
    children = [
      # Add LoginActor as a child process with no initialization arguments
      {FourcastersApiClient.LoginActor, []},
      # Add GameCache as a child process with no initialization arguments
      {FourcastersApiClient.GameCache, []},
      # Add PollOrderBookActor as a child process with no initialization arguments
      {FourcastersApiClient.PollOrderBookActor, []},
    ]

    # Initialize the supervisor with the children and a restart strategy of :one_for_one
    Supervisor.init(children, strategy: :one_for_one)
  end
end
