defmodule FourcastersApiClientTest do
  use ExUnit.Case
  doctest FourcastersApiClient

  test "greets the world" do
    assert FourcastersApiClient.hello() == :world
  end
end
