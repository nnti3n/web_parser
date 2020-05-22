defmodule Play.Application do
  use Application
  require Logger

  def start(_type, _args) do
    IO.puts("PORT: #{System.get_env("PORT")}")

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Play.Router,
        options: [port: System.get_env("PORT") || 8080]
      )
    ]

    opts = [strategy: :one_for_one, name: Play.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
