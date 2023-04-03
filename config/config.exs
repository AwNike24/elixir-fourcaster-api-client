use Mix.Config

config :fourcasters_api_client, :poll_interval, System.get_env("FOURCASTERS_POLL_INTERVAL") || 60000
config :fourcasters_api_client, :username, System.get_env("FOURCASTERS_API_USERNAME")
config :fourcasters_api_client, :password, System.get_env("FOURCASTERS_API_PASSWORD")
