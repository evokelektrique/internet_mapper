defmodule InternetMapper.TaskPipeline do
  alias InternetMapper.{DNSLookup, BatchLogger, IPGenerator}

  def run(start_ip, count) do
    ip_list = IPGenerator.generate_ips(start_ip, count)

    ip_list
    |> Flow.from_enumerable()
    |> Flow.partition(stages: System.schedulers_online())
    |> Flow.map(&process_ip/1)
    |> Flow.run()

    :ok
  end

  defp process_ip(ip) do
    timestamp = DateTime.utc_now() |> DateTime.truncate(:second)
    dns = DNSLookup.lookup(ip)

    hex_color = if dns == "N/A", do: "#FF0000", else: "#00FF00"

    result_map = %{
      timestamp: timestamp,
      ip: ip,
      dns: dns,
      hex_color: hex_color
    }

    BatchLogger.log_result(result_map)
  end
end
