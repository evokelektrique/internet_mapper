defmodule DNSLookup do
  @doc """
  Performs a reverse DNS lookup for the given IP (as a string).
  Returns the hostname as a string if found, otherwise "N/A".
  """
  def lookup(ip) when is_binary(ip) do
    ip_tuple =
      ip
      |> String.split(".")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    case :inet.gethostbyaddr(ip_tuple) do
      {:ok, {:hostent, hostname, _aliases, _addrtype, _length, _addresses}} ->
        List.to_string(hostname)
      {:error, _reason} ->
        "N/A"
    end
  end
end
