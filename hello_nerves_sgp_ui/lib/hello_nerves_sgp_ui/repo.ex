defmodule HelloNervesSgpUi.Repo do
  use Ecto.Repo,
    otp_app: :hello_nerves_sgp_ui,
    adapter: Ecto.Adapters.SQLite3
end
