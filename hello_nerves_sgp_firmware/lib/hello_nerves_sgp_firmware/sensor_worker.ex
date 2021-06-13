defmodule HelloNervesSgpFirmware.SensorWorker do
  @moduledoc """
  Manages connection to sensors and periodically fetch data from them.

  HelloNervesSgpFirmware.SensorWorker.start_link([])
  """

  use GenServer, restart: :transient

  alias HelloNervesSgpFirmware.Measurement

  require Logger

  @polling_interval_ms :timer.seconds(1)

  defmodule State do
    @moduledoc false
    defstruct [:bmp280, :sgp40, :last_measurement]
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_args) do
    with {:ok, bmp280} <- BMP280.start_link([]),
         {:ok, sgp40} <- SGP40.start_link([]) do
      {:ok, %State{bmp280: bmp280, sgp40: sgp40}, {:continue, :start_measuring}}
    else
      _error -> {:stop, :device_not_found}
    end
  end

  @impl GenServer
  def handle_continue(:start_measuring, state) do
    Logger.info("[HelloNervesSgp] Start measuring")

    state = read_and_maybe_put_measurement(state)
    Process.send_after(self(), :tick, @polling_interval_ms)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(:tick, state) do
    state = read_and_maybe_put_measurement(state)
    Process.send_after(self(), :tick, @polling_interval_ms)

    {:noreply, state}
  end

  defp read_and_maybe_put_measurement(state) do
    case read_sensors(state) do
      {:ok, measurement} ->
        struct!(state, last_measurement: measurement)

      {:error, reason} ->
        Logger.error("[HelloNervesSgp] Error reading measurement: #{inspect(reason)}")
        state
    end
  end

  defp read_sensors(state) do
    with {:ok, bmp280_result} <- BMP280.measure(state.bmp280),
         %{humidity_rh: humidity_rh, temperature_c: temperature_c} = bmp280_result,
         :ok <- SGP40.update_rht(state.sgp40, humidity_rh, temperature_c),
         {:ok, sgp40_result} <- SGP40.measure(state.sgp40) do
      %{voc_index: voc_index, timestamp_ms: timestamp_ms} = sgp40_result

      measurement = %Measurement{
        humidity_rh: humidity_rh,
        temperature_c: temperature_c,
        voc_index: voc_index,
        timestamp_ms: timestamp_ms
      }

      Logger.debug("[HelloNervesSgp] #{inspect(Map.from_struct(measurement))}")

      {:ok, measurement}
    end
  end
end
