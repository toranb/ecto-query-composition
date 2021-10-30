defmodule Bulk.Repo do
  use Ecto.Repo,
    otp_app: :bulk,
    adapter: Ecto.Adapters.Postgres
end
