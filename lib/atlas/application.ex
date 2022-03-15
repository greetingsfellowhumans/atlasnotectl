defmodule Atlas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Atlas.Repo,
      # Start the Telemetry supervisor
      AtlasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Atlas.PubSub},
      AtlasWeb.Presence,
      # Start the Endpoint (http/https)
      AtlasWeb.Endpoint,

      Atlas.SorceryStorage,
      Sorcery.PortalMonitor,
      #{Sorcery.Storage.GenserverAdapter, name: Atlas.Storage},
      # Start a worker by calling: Atlas.Worker.start_link(arg)
      # {Atlas.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Atlas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AtlasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
