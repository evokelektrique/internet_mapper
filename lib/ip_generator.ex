defmodule IPGenerator do
  @moduledoc """
  Generates incremental IPv4 addresses starting from a given IP.
  """
  import Bitwise

  @doc """
  Generates a list of `count` incremental IP addresses starting from `start_ip`.

  ## Example

      iex> IPGenerator.generate_ips("1.0.0.0", 3)
      ["1.0.0.0", "1.0.0.1", "1.0.0.2"]
  """
  def generate_ips(start_ip, count) when is_binary(start_ip) and is_integer(count) and count > 0 do
    start_int = ip_to_integer(start_ip)
    Enum.map(0..(count - 1), fn i ->
      integer_to_ip(start_int + i)
    end)
  end

  defp ip_to_integer(ip) do
    ip
    |> String.split(".")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn octet, acc -> acc * 256 + octet end)
  end

  defp integer_to_ip(int) do
    a = div(int, 256 * 256 * 256) &&& 0xFF
    b = div(int, 256 * 256) &&& 0xFF
    c = div(int, 256) &&& 0xFF
    d = int &&& 0xFF
    "#{a}.#{b}.#{c}.#{d}"
  end
end
