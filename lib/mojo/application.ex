defmodule Mojo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MojoWeb.Telemetry,
      Mojo.Repo,
      {DNSCluster, query: Application.get_env(:mojo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mojo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mojo.Finch},
      # Start a worker by calling: Mojo.Worker.start_link(arg)
      # {Mojo.Worker, arg},
      # Start to serve requests, typically the last entry
      MojoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mojo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MojoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
