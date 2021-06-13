defmodule HelloNervesSgpUi.EnvironmentTest do
  use HelloNervesSgpUi.DataCase

  alias HelloNervesSgpUi.Environment

  describe "measurements" do
    alias HelloNervesSgpUi.Environment.Measurement

    @valid_attrs %{
      humidity_rh: 120.5,
      temperature_c: 120.5,
      voc_index: 42
    }
    @update_attrs %{
      humidity_rh: 456.7,
      temperature_c: 456.7,
      voc_index: 43
    }
    @invalid_attrs %{humidity_rh: nil, temperature_c: nil, voc_index: nil}

    def measurement_fixture(attrs \\ %{}) do
      {:ok, measurement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Environment.create_measurement()

      measurement
    end

    test "list_measurements/0 returns all measurements" do
      measurement = measurement_fixture()
      assert Environment.list_measurements() == [measurement]
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = measurement_fixture()
      assert Environment.get_measurement!(measurement.id) == measurement
    end

    test "create_measurement/1 with valid data creates a measurement" do
      assert {:ok, %Measurement{} = measurement} = Environment.create_measurement(@valid_attrs)
      assert measurement.humidity_rh == 120.5
      assert measurement.temperature_c == 120.5
      assert measurement.voc_index == 42
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Environment.create_measurement(@invalid_attrs)
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = measurement_fixture()

      assert {:ok, %Measurement{} = measurement} =
               Environment.update_measurement(measurement, @update_attrs)

      assert measurement.humidity_rh == 456.7
      assert measurement.temperature_c == 456.7
      assert measurement.voc_index == 43
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = measurement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Environment.update_measurement(measurement, @invalid_attrs)

      assert measurement == Environment.get_measurement!(measurement.id)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = measurement_fixture()
      assert {:ok, %Measurement{}} = Environment.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Environment.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = measurement_fixture()
      assert %Ecto.Changeset{} = Environment.change_measurement(measurement)
    end
  end
end
