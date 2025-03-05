defmodule IPMapper.Consumer do
  use GenStage

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [IPMapper.Producer]}
  end

  def handle_events(ip_list, _from, state) do
    Enum.each(ip_list, fn ip ->
      Task.start(fn ->
        http_result = MintFetcher.fetch(ip)
        dns = DNSLookup.lookup(ip)
        {result, hex_color} =
          case http_result do
            {:success, code} ->
              { {:success, code}, "#00FF00" }
            {:failure, reason} ->
              { {:failure, reason}, "#FF0000" }
          end

        CSVLogger.log_result(ip, dns, result, hex_color)
        ProgressLogger.increment()
      end)
    end)
    {:noreply, [], state}
  end
end
