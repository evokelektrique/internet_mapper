defmodule ProgressLogger do
  use GenServer

  @tick_interval 1000

  ## Client API

  def start_link(total) do
    GenServer.start_link(__MODULE__, total, name: __MODULE__)
  end

  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  ## Server Callbacks

  def init(total) do
    state = %{
      total: total,
      completed: 0,
      start_time: :os.system_time(:millisecond)
    }
    Process.send_after(self(), :tick, @tick_interval)
    {:ok, state}
  end

  def handle_cast(:increment, state) do
    {:noreply, %{state | completed: state.completed + 1}}
  end

  def handle_info(:tick, state) do
    now = :os.system_time(:millisecond)
    elapsed = now - state.start_time
    remaining = state.total - state.completed
    avg_per_item = if state.completed > 0, do: elapsed / state.completed, else: 0
    eta = if state.completed > 0, do: trunc(remaining * avg_per_item / 1000), else: :unknown

    IO.puts("[#{DateTime.utc_now() |> DateTime.to_iso8601()}] Processed: #{state.completed}/#{state.total} | Remaining: #{remaining} | ETA: #{eta} sec")
    Process.send_after(self(), :tick, @tick_interval)
    {:noreply, state}
  end
end
