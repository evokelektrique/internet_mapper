defmodule InternetMapper.BatchLogger do
  use GenServer

  # Flush every 5 seconds
  @flush_interval 5_000
  # Flush when reaching 5,000 records
  @flush_threshold 5_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    schedule_flush()
    {:ok, state}
  end

  def log_result(result) do
    GenServer.cast(__MODULE__, {:log, result})
  end

  def handle_cast({:log, result}, state) do
    new_state = [result | state]

    if length(new_state) >= @flush_threshold do
      flush(new_state)
      {:noreply, []}
    else
      {:noreply, new_state}
    end
  end

  def handle_info(:flush, state) do
    flush(state)
    schedule_flush()
    {:noreply, []}
  end

  defp flush(results) when is_list(results) and results != [] do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    records =
      Enum.map(results, fn result ->
        id = :erlang.unique_integer([:positive, :monotonic])

        %InternetMapper.Result{
          id: id,
          timestamp: result.timestamp || now,
          ip: result.ip,
          dns: result.dns,
          hex_color: result.hex_color
        }
      end)

      Memento.transaction(fn ->
        Enum.each(records, fn record ->
          Memento.Query.write(record)
        end)
      end)

      IO.puts("✅ Flushed #{length(records)} records to Mnesia")
  end

  defp flush(_), do: :ok

  defp schedule_flush do
    Process.send_after(self(), :flush, @flush_interval)
  end
end
