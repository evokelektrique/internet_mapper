
defmodule InternetMapper.IPGenerator do
  import Bitwise

  def generate_ips(start_ip, count) do
    case :inet.parse_address(String.to_charlist(start_ip)) do
      {:ok, {a, b, c, d}} ->
        start_int = (a <<< 24) + (b <<< 16) + (c <<< 8) + d

        Enum.map(0..(count - 1), fn i ->
          integer_to_ip(start_int + i)
        end)

      _ ->
        raise ArgumentError, "Invalid IP address format: #{start_ip}"
    end
  end

  defp integer_to_ip(int) do
    a = (int >>> 24) &&& 255
    b = (int >>> 16) &&& 255
    c = (int >>> 8) &&& 255
    d = int &&& 255
    "#{a}.#{b}.#{c}.#{d}"
  end
end
