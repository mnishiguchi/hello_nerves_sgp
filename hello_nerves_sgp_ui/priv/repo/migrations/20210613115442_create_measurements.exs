defmodule HelloNervesSgpUi.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :voc_index, :integer
      add :temperature_c, :float
      add :humidity_rh, :float

      timestamps()
    end
  end
end
