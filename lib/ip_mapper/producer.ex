defmodule IPMapper.Producer do
  use GenStage

  def start_link(ip_list) do
    GenStage.start_link(__MODULE__, ip_list, name: __MODULE__)
  end

  def init(ip_list) do
    {:producer, ip_list}
  end

  def handle_demand(demand, state) when demand > 0 do
    {to_send, remaining} = Enum.split(state, demand)
    {:noreply, to_send, remaining}
  end
end
