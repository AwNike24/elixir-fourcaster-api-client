defmodule FourcastersApiClient.Application do
  use Application

  def start(_type, _args) do
    children = [
      {FourcastersApiClient.LoginActor, []},
      {FourcastersApiClient.GameCache, []},
      {FourcastersApiClient.PollOrderBookActor, []}
    ]

    opts = [strategy: :one_for_one, name: FourcastersApiClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
