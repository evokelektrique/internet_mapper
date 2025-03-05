defmodule CSVLogger do
  @csv_file "results.csv"

  @doc """
  Initializes the CSV file by writing a header if it doesn't exist.
  """
  def init do
    unless File.exists?(@csv_file) do
      header = "timestamp,ip,dns,result,hex_color\n"
      File.write!(@csv_file, header)
    end
  end

  @doc """
  Appends a line to the CSV file with timestamp, IP, DNS name, HTTP result, and hex color.
  Also prints a debug log to the console.
  """
  def log_result(ip, dns, result, hex_color) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()
    line = format_line(timestamp, ip, dns, result, hex_color)
    File.write!(@csv_file, line, [:append])
    IO.puts("Logged #{ip}: #{line}")
  end

  defp format_line(timestamp, ip, dns, result, hex_color) do
    result_str =
      case result do
        {:success, code} -> "success (#{code})"
        {:failure, reason} -> "failure (#{inspect(reason)})"
      end

    "#{timestamp},#{ip},#{dns},#{result_str},#{hex_color}\n"
  end
end
