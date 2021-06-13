defmodule HelloNervesSgpUi.Environment.Measurement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "measurements" do
    field :humidity_rh, :float
    field :temperature_c, :float
    field :voc_index, :integer

    timestamps()
  end

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [:voc_index, :temperature_c, :humidity_rh])
    |> validate_required([:voc_index, :temperature_c, :humidity_rh])
  end
end
