defmodule Mojo.Repo do
  use Ecto.Repo,
    otp_app: :mojo,
    adapter: Ecto.Adapters.Postgres
end
